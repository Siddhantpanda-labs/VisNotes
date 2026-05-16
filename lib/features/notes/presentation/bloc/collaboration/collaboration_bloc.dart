import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/cloud_sync_repository.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../domain/entities/collaborator_profile.dart';

part 'collaboration_event.dart';
part 'collaboration_state.dart';

class CollaborationBloc extends Bloc<CollaborationEvent, CollaborationState> {
  final CloudSyncRepository cloudSync;
  final NoteRepository noteRepository;
  final String currentUserEmail;

  CollaborationBloc({
    required this.cloudSync,
    required this.noteRepository,
    required this.currentUserEmail,
  }) : super(CollaborationInitial()) {
    on<LoadCollaborators>(_onLoadCollaborators);
    on<AddCollaborator>(_onAddCollaborator);
    on<RemoveCollaborator>(_onRemoveCollaborator);
    on<SetAdminStatus>(_onSetAdminStatus);
    on<TransferOwnership>(_onTransferOwnership);
    on<LeaveCollaboration>(_onLeaveCollaboration);
  }

  // ─── Handlers ─────────────────────────────────────────────────────────────

  Future<void> _onLoadCollaborators(
    LoadCollaborators event,
    Emitter<CollaborationState> emit,
  ) async {
    emit(CollaborationLoading());
    try {
      final item = event.isFolder
          ? await noteRepository.getFolderById(event.itemId)
          : await noteRepository.getNoteById(event.itemId);

      if (item == null) {
        emit(const CollaborationError('Item not found.'));
        return;
      }

      final driveFileId = event.isFolder
          ? (item as dynamic).driveFileId as String?
          : (item as dynamic).driveFileId as String?;

      final ownerEmail = (item as dynamic).ownerEmail as String? ?? '';
      final adminEmails = List<String>.from((item as dynamic).adminEmails as List);

      List<CollaboratorProfile> profiles = [];

      if (driveFileId != null) {
        profiles = await cloudSync.getCollaboratorProfiles(
          driveFileId, ownerEmail, adminEmails);
      }

      // If Drive returns empty (e.g. item not yet on Drive), build from local data
      if (profiles.isEmpty) {
        final collaborators = List<String>.from((item as dynamic).collaborators as List);
        profiles = [
          // Always include the owner
          CollaboratorProfile(
            email: ownerEmail,
            displayName: ownerEmail,
            role: CollaboratorRole.owner,
          ),
          ...collaborators.map((e) => CollaboratorProfile(
                email: e,
                displayName: e,
                role: adminEmails.contains(e)
                    ? CollaboratorRole.admin
                    : CollaboratorRole.collaborator,
              )),
        ];
      }

      final isCurrentUserAdmin = profiles.any(
        (p) => p.email == currentUserEmail && p.isAdmin,
      );
      final isCurrentUserOwner = profiles.any(
        (p) => p.email == currentUserEmail && p.isOwner,
      );

      emit(CollaborationLoaded(
        itemId: event.itemId,
        isFolder: event.isFolder,
        profiles: profiles,
        isCurrentUserAdmin: isCurrentUserAdmin,
        isCurrentUserOwner: isCurrentUserOwner,
      ));
    } catch (e) {
      emit(CollaborationError(e.toString()));
    }
  }

  Future<void> _onAddCollaborator(
    AddCollaborator event,
    Emitter<CollaborationState> emit,
  ) async {
    final prev = state;
    emit(CollaborationLoading());
    final result = await cloudSync.addCollaborator(
      itemId: event.itemId,
      isFolder: event.isFolder,
      email: event.email,
      currentUserEmail: currentUserEmail,
    );
    if (result is CollaborationSuccess) {
      emit(const CollaborationActionSuccess('Collaborator added successfully.'));
      add(LoadCollaborators(itemId: event.itemId, isFolder: event.isFolder));
    } else {
      emit(CollaborationError((result as CollaborationFailure).reason));
      if (prev is CollaborationLoaded) emit(prev);
    }
  }

  Future<void> _onRemoveCollaborator(
    RemoveCollaborator event,
    Emitter<CollaborationState> emit,
  ) async {
    final prev = state;
    emit(CollaborationLoading());
    final result = await cloudSync.removeCollaborator(
      itemId: event.itemId,
      isFolder: event.isFolder,
      emailToRemove: event.emailToRemove,
      currentUserEmail: currentUserEmail,
    );
    if (result is CollaborationSuccess) {
      emit(const CollaborationActionSuccess('Collaborator removed.'));
      add(LoadCollaborators(itemId: event.itemId, isFolder: event.isFolder));
    } else {
      emit(CollaborationError((result as CollaborationFailure).reason));
      if (prev is CollaborationLoaded) emit(prev);
    }
  }

  Future<void> _onSetAdminStatus(
    SetAdminStatus event,
    Emitter<CollaborationState> emit,
  ) async {
    final prev = state;
    emit(CollaborationLoading());
    final result = await cloudSync.setAdminStatus(
      itemId: event.itemId,
      isFolder: event.isFolder,
      targetEmail: event.targetEmail,
      makeAdmin: event.makeAdmin,
      currentUserEmail: currentUserEmail,
    );
    if (result is CollaborationSuccess) {
      final msg = event.makeAdmin ? 'Made admin.' : 'Admin role removed.';
      emit(CollaborationActionSuccess(msg));
      add(LoadCollaborators(itemId: event.itemId, isFolder: event.isFolder));
    } else {
      emit(CollaborationError((result as CollaborationFailure).reason));
      if (prev is CollaborationLoaded) emit(prev);
    }
  }

  Future<void> _onTransferOwnership(
    TransferOwnership event,
    Emitter<CollaborationState> emit,
  ) async {
    final prev = state;
    emit(CollaborationLoading());
    final result = await cloudSync.transferOwnership(
      itemId: event.itemId,
      isFolder: event.isFolder,
      newOwnerEmail: event.newOwnerEmail,
      currentUserEmail: currentUserEmail,
    );
    if (result is CollaborationSuccess) {
      emit(const CollaborationActionSuccess('Ownership transferred. You are now a collaborator.'));
      add(LoadCollaborators(itemId: event.itemId, isFolder: event.isFolder));
    } else {
      emit(CollaborationError((result as CollaborationFailure).reason));
      if (prev is CollaborationLoaded) emit(prev);
    }
  }

  Future<void> _onLeaveCollaboration(
    LeaveCollaboration event,
    Emitter<CollaborationState> emit,
  ) async {
    emit(CollaborationLoading());
    final result = await cloudSync.leaveCollaboration(
      itemId: event.itemId,
      isFolder: event.isFolder,
      currentUserEmail: currentUserEmail,
    );
    if (result is CollaborationSuccess) {
      emit(const CollaborationActionSuccess('You have left the collaboration.'));
    } else {
      emit(CollaborationError((result as CollaborationFailure).reason));
    }
  }
}
