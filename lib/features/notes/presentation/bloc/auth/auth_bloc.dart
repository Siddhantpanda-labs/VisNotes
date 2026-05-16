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
        .debounceTime(const Duration(minutes: 1))
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
        // Also fetch shared items on startup
        await cloudSyncRepository.fetchSharedItems();
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
        // Step 1: Save user settings in a transaction (fast, sync-safe)
        final isar = await repository.db;
        IsarUserSettings settings = IsarUserSettings();
        await isar.writeTxn(() async {
          settings = await isar.isarUserSettings.where().findFirst() ?? IsarUserSettings();
          settings.email      = cloudUser.email;
          settings.name       = cloudUser.name;
          settings.avatarUrl  = cloudUser.photoUrl;
          settings.isLoggedIn = true;
          settings.googleAccessToken  = cloudUser.credentials.accessToken.data;
          settings.googleRefreshToken = cloudUser.credentials.refreshToken;
          settings.googleTokenExpiry  = cloudUser.credentials.accessToken.expiry;
          await isar.isarUserSettings.put(settings);
        });

        // Step 2: Show the user as logged in immediately
        emit(Authenticated(settings));

        // Step 3: Restore account backup (outside transaction — this writes to Isar internally)
        print('[AuthBloc] Restoring account data from Drive...');
        await cloudSyncRepository.restoreFromDrive();

        // Step 3.5: Clean up any shared notes whose access was revoked
        print('[AuthBloc] Cleaning up revoked shared items...');
        await cloudSyncRepository.cleanupRevokedSharedItems();

        // Step 4: Fetch shared items (outside transaction)
        print('[AuthBloc] Fetching shared items...');
        await cloudSyncRepository.fetchSharedItems();

        // Step 5: Re-fetch final user state and emit
        final finalUser = await repository.getUserSettings();
        if (finalUser != null) emit(Authenticated(finalUser));
      } else {
        emit(Unauthenticated());
      }
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    if (state is Authenticated) {
      final user = (state as Authenticated).user;
      // 1. Perform final sync if cloud sync is enabled
      if (user.isCloudSyncEnabled) {
        print('[AuthBloc] Performing final sync before logout...');
        await cloudSyncRepository.syncToDrive(user.email);
      }
    }

    try {
      // 2. Clear account data from local DB (keep only backup-excluded notes)
      await repository.clearAccountData();
      
      // 3. Sign out from Google
      await cloudSyncRepository.signOut();

      // 4. Update user settings in DB
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
      
      // IMPORTANT: After sync, we MUST fetch the latest user settings from DB 
      // because CloudSyncRepository might have refreshed tokens in the background.
      // If we use the old 'user' object, we will overwrite the new tokens with old ones.
      final latestUser = await repository.getUserSettings();
      if (latestUser == null) return;

      if (result.success) {
        final isar = await repository.db;
        await isar.writeTxn(() async {
          latestUser.lastSyncTime = DateTime.now();
          await isar.isarUserSettings.put(latestUser);
        });
        emit(Authenticated(latestUser));
      } else {
        print('[AuthBloc] Sync error: ${result.message}');
        emit(Authenticated(latestUser));
      }
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
      
      final latestUser = await repository.getUserSettings();
      if (latestUser == null) return;

      if (restored) {
        final isar = await repository.db;
        await isar.writeTxn(() async {
          latestUser.lastSyncTime = DateTime.now();
          await isar.isarUserSettings.put(latestUser);
        });
      }
      emit(Authenticated(latestUser));
    } catch (e) {
      print('[AuthBloc] Restore failed: $e');
      emit(Authenticated(user));
    }
  }
}
