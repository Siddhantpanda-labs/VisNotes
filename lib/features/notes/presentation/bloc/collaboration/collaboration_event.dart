part of 'collaboration_bloc.dart';

abstract class CollaborationEvent {
  const CollaborationEvent();
}

class LoadCollaborators extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  const LoadCollaborators({required this.itemId, required this.isFolder});
}

class AddCollaborator extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  final String email;
  const AddCollaborator({required this.itemId, required this.isFolder, required this.email});
}

class RemoveCollaborator extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  final String emailToRemove;
  const RemoveCollaborator({
    required this.itemId,
    required this.isFolder,
    required this.emailToRemove,
  });
}

class SetAdminStatus extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  final String targetEmail;
  final bool makeAdmin;
  const SetAdminStatus({
    required this.itemId,
    required this.isFolder,
    required this.targetEmail,
    required this.makeAdmin,
  });
}

class TransferOwnership extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  final String newOwnerEmail;
  const TransferOwnership({
    required this.itemId,
    required this.isFolder,
    required this.newOwnerEmail,
  });
}

class LeaveCollaboration extends CollaborationEvent {
  final String itemId;
  final bool isFolder;
  const LeaveCollaboration({required this.itemId, required this.isFolder});
}
