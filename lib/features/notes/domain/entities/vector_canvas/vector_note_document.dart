import 'vector_element.dart';

/// The top-level domain entity representing an entire Infinite Vector Canvas Note.
class VectorNoteDocument {
  final String id;
  final String title;
  final List<VectorElement> elements;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Spatial Dashboard Position
  final double dashboardX;
  final double dashboardY;
  final bool isPinned;
  final String? parentFolderId;
  final bool isDeleted;
  final DateTime? deletedAt;

  // Collaboration Details
  final String? ownerEmail;
  final String? lastEditedBy;
  final String? driveFileId;
  final bool isShared;
  final List<String> collaborators;
  final List<String> adminEmails;

  const VectorNoteDocument({
    required this.id,
    required this.title,
    required this.elements,
    required this.createdAt,
    required this.updatedAt,
    this.dashboardX = 0.0,
    this.dashboardY = 0.0,
    this.isPinned = false,
    this.parentFolderId,
    this.isDeleted = false,
    this.deletedAt,
    this.ownerEmail,
    this.lastEditedBy,
    this.driveFileId,
    this.isShared = false,
    this.collaborators = const [],
    this.adminEmails = const [],
  });

  VectorNoteDocument copyWith({
    String? id,
    String? title,
    List<VectorElement>? elements,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? dashboardX,
    double? dashboardY,
    bool? isPinned,
    String? parentFolderId,
    bool? isDeleted,
    DateTime? deletedAt,
    String? ownerEmail,
    String? lastEditedBy,
    String? driveFileId,
    bool? isShared,
    List<String>? collaborators,
    List<String>? adminEmails,
  }) {
    return VectorNoteDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      elements: elements ?? this.elements,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dashboardX: dashboardX ?? this.dashboardX,
      dashboardY: dashboardY ?? this.dashboardY,
      isPinned: isPinned ?? this.isPinned,
      parentFolderId: parentFolderId ?? this.parentFolderId,
      isDeleted: isDeleted ?? this.isDeleted,
      deletedAt: deletedAt ?? this.deletedAt,
      ownerEmail: ownerEmail ?? this.ownerEmail,
      lastEditedBy: lastEditedBy ?? this.lastEditedBy,
      driveFileId: driveFileId ?? this.driveFileId,
      isShared: isShared ?? this.isShared,
      collaborators: collaborators ?? this.collaborators,
      adminEmails: adminEmails ?? this.adminEmails,
    );
  }
}
