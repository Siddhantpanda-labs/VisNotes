part of 'collaboration_bloc.dart';

abstract class CollaborationState {
  const CollaborationState();
}

class CollaborationInitial extends CollaborationState {}

class CollaborationLoading extends CollaborationState {}

class CollaborationLoaded extends CollaborationState {
  final String itemId;
  final bool isFolder;
  final List<CollaboratorProfile> profiles;
  final bool isCurrentUserAdmin;
  final bool isCurrentUserOwner;

  const CollaborationLoaded({
    required this.itemId,
    required this.isFolder,
    required this.profiles,
    required this.isCurrentUserAdmin,
    required this.isCurrentUserOwner,
  });
}

class CollaborationActionSuccess extends CollaborationState {
  final String message;
  const CollaborationActionSuccess(this.message);
}

class CollaborationError extends CollaborationState {
  final String message;
  const CollaborationError(this.message);
}
