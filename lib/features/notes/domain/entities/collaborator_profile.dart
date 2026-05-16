/// Represents a single collaborator's profile as resolved from Google Drive.
///
/// This is a pure-Dart UI-facing model — it is NOT stored in Isar.
/// It is populated on-demand by [CloudSyncRepository.getCollaboratorProfiles].
library collaborator_profile;

/// The role a user holds on a shared item.
enum CollaboratorRole { owner, admin, collaborator }

class CollaboratorProfile {
  final String email;
  final String displayName;
  final String? photoUrl;
  final CollaboratorRole role;
  /// The Drive permissionId for this user (needed to revoke access via Drive API).
  final String? permissionId;

  const CollaboratorProfile({
    required this.email,
    required this.displayName,
    this.photoUrl,
    required this.role,
    this.permissionId,
  });

  bool get isOwner        => role == CollaboratorRole.owner;
  bool get isAdmin        => role == CollaboratorRole.admin || isOwner;
  bool get isCollaborator => role == CollaboratorRole.collaborator;

  /// Returns the initials to display when no photo is available (max 2 chars).
  String get initials {
    final parts = displayName.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
    return displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';
  }

  CollaboratorProfile copyWith({
    String? email,
    String? displayName,
    String? photoUrl,
    CollaboratorRole? role,
    String? permissionId,
  }) =>
      CollaboratorProfile(
        email: email ?? this.email,
        displayName: displayName ?? this.displayName,
        photoUrl: photoUrl ?? this.photoUrl,
        role: role ?? this.role,
        permissionId: permissionId ?? this.permissionId,
      );
}
