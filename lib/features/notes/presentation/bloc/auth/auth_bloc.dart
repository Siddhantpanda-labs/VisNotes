import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:isar/isar.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../../../data/models/isar_note_model.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../data/repositories/cloud_sync_repository.dart';

// ─── Events ────────────────────────────────────────────────────────────────

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthAppStarted     extends AuthEvent {}
class GoogleLoginRequested extends AuthEvent {}
class LogoutRequested    extends AuthEvent {}
class SyncNow            extends AuthEvent {}
class RestoreFromDrive   extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String email;
  final String password;
  const LoginRequested(this.email, this.password);
}

class ToggleCloudSync extends AuthEvent {
  final bool enabled;
  const ToggleCloudSync(this.enabled);
}

class UpdateProfile extends AuthEvent {
  final String name;
  const UpdateProfile(this.name);
}

// ─── States ────────────────────────────────────────────────────────────────

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial      extends AuthState {}
class AuthLoading      extends AuthState {}
class AuthSyncing      extends AuthState {
  final IsarUserSettings user;
  const AuthSyncing(this.user);
  @override List<Object?> get props => [user];
}
class AuthRestoring    extends AuthState {}

class Authenticated extends AuthState {
  final IsarUserSettings user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// ─── Bloc ──────────────────────────────────────────────────────────────────

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final NoteRepository repository;
  final CloudSyncRepository cloudSyncRepository;
  StreamSubscription? _syncSubscription;

  AuthBloc(this.repository, this.cloudSyncRepository) : super(AuthInitial()) {
    on<AuthAppStarted>(_onAppStarted);
    on<LoginRequested>(_onLoginRequested);
    on<GoogleLoginRequested>(_onGoogleLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<ToggleCloudSync>(_onToggleCloudSync);
    on<UpdateProfile>(_onUpdateProfile);
    on<SyncNow>(_onSyncNow);
    on<RestoreFromDrive>(_onRestoreFromDrive);

    // Auto-sync: debounce 5 s after last data change
    _syncSubscription = repository.onDataChanged
        .debounceTime(const Duration(seconds: 5))
        .listen((_) {
          if (state is Authenticated &&
              (state as Authenticated).user.isCloudSyncEnabled) {
            add(SyncNow());
          }
        });
  }

  @override
  Future<void> close() {
    _syncSubscription?.cancel();
    return super.close();
  }

  // ─── Handlers ────────────────────────────────────────────────────────────

  Future<void> _onAppStarted(AuthAppStarted event, Emitter<AuthState> emit) async {
    try {
      final isar     = await repository.db;
      final settings = await isar.isarUserSettings.where().findFirst();
      if (settings != null && settings.isLoggedIn) {
        // Restore Cloud Sync session if tokens exist
        if (settings.googleAccessToken != null) {
          try {
            final credentials = AccessCredentials(
              AccessToken('Bearer', settings.googleAccessToken!, settings.googleTokenExpiry!.toUtc()),
              settings.googleRefreshToken,
              ['https://www.googleapis.com/auth/drive.file', 'email', 'profile'],
            );
            cloudSyncRepository.restoreSession(credentials);
          } catch (e) {
            print('[AuthBloc] Failed to restore session: $e');
          }
        }
        emit(Authenticated(settings));
      } else {
        emit(Unauthenticated());
      }
    } catch (_) {
      emit(Unauthenticated());
    }
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await Future.delayed(const Duration(seconds: 1));
      final isar = await repository.db;
      await isar.writeTxn(() async {
        var settings = await isar.isarUserSettings.where().findFirst();
        if (settings == null) {
          settings = IsarUserSettings()
            ..email     = event.email
            ..name      = event.email.split('@').first
            ..isLoggedIn = true;
        } else {
          settings.email     = event.email;
          settings.isLoggedIn = true;
          settings.name     ??= event.email.split('@').first;
        }
        await isar.isarUserSettings.put(settings);
        emit(Authenticated(settings));
      });
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onGoogleLoginRequested(GoogleLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final cloudUser = await cloudSyncRepository.signIn();
      if (cloudUser != null) {
        final isar = await repository.db;
        await isar.writeTxn(() async {
          var settings = await isar.isarUserSettings.where().findFirst();
          if (settings == null) {
            settings = IsarUserSettings();
          }
          
          settings.email      = cloudUser.email;
          settings.name       = cloudUser.name;
          settings.avatarUrl  = cloudUser.photoUrl;
          settings.isLoggedIn = true;
          
          // Save tokens for session restoration
          settings.googleAccessToken  = cloudUser.credentials.accessToken.data;
          settings.googleRefreshToken = cloudUser.credentials.refreshToken;
          settings.googleTokenExpiry   = cloudUser.credentials.accessToken.expiry;
          
          await isar.isarUserSettings.put(settings);
          emit(Authenticated(settings));
        });
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    try {
      await cloudSyncRepository.signOut();
      final isar = await repository.db;
      await isar.writeTxn(() async {
        final settings = await isar.isarUserSettings.where().findFirst();
        if (settings != null) {
          settings.isLoggedIn = false;
          settings.googleAccessToken = null;
          settings.googleRefreshToken = null;
          await isar.isarUserSettings.put(settings);
        }
      });
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onToggleCloudSync(ToggleCloudSync event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      final user = (state as Authenticated).user;
      final isar = await repository.db;
      await isar.writeTxn(() async {
        user.isCloudSyncEnabled = event.enabled;
        await isar.isarUserSettings.put(user);
        emit(Authenticated(user));
      });
    }
  }

  Future<void> _onUpdateProfile(UpdateProfile event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      final user = (state as Authenticated).user;
      final isar = await repository.db;
      await isar.writeTxn(() async {
        user.name = event.name;
        await isar.isarUserSettings.put(user);
        emit(Authenticated(user));
      });
    }
  }

  Future<void> _onSyncNow(SyncNow event, Emitter<AuthState> emit) async {
    if (state is! Authenticated) return;
    final user = (state as Authenticated).user;
    emit(AuthSyncing(user));
    try {
      final result = await cloudSyncRepository.syncToDrive(user.email);
      if (result.success) {
        final isar = await repository.db;
        await isar.writeTxn(() async {
          user.lastSyncTime = DateTime.now();
          await isar.isarUserSettings.put(user);
        });
      } else {
        print('[AuthBloc] Sync error: ${result.message}');
      }
      emit(Authenticated(user));
    } catch (e) {
      print('[AuthBloc] Sync failed: $e');
      emit(Authenticated(user));
    }
  }

  Future<void> _onRestoreFromDrive(RestoreFromDrive event, Emitter<AuthState> emit) async {
    if (state is! Authenticated) return;
    final user = (state as Authenticated).user;
    emit(AuthRestoring());
    try {
      final restored = await cloudSyncRepository.restoreFromDrive();
      if (restored) {
        final isar = await repository.db;
        await isar.writeTxn(() async {
          user.lastSyncTime = DateTime.now();
          await isar.isarUserSettings.put(user);
        });
      }
      emit(Authenticated(user));
    } catch (e) {
      print('[AuthBloc] Restore failed: $e');
      emit(Authenticated(user));
    }
  }
}
