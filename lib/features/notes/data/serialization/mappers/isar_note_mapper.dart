/// Mapper: Isar storage models ↔ DTOs.
///
/// This is the only place in the codebase that knows about both
/// [IsarNoteDocument] (storage layer) and [NoteDto] (serialization layer).
/// Keep all Isar-specific logic here so other serialization code stays clean.
library isar_mapper;

import '../../models/isar_note_model.dart';
import '../dto/note_dto.dart';

// ─── Note ──────────────────────────────────────────────────────────────────

class IsarNoteMapper {
  IsarNoteMapper._();

  static NoteDto toDto(IsarNoteDocument note) => NoteDto(
        id: note.id!,
        title: note.title,
        createdAt: note.createdAt,
        updatedAt: note.updatedAt,
        dashboardX: note.dashboardX,
        dashboardY: note.dashboardY,
        isPinned: note.isPinned,
        parentFolderId: note.parentFolderId,
        isDeleted: note.isDeleted,
        excludeFromBackup: note.excludeFromBackup,
        deletedAt: note.deletedAt,
        tags: List<String>.from(note.tags),
        pages: note.pages.map(_pageToDto).toList(),
        ownerEmail: note.ownerEmail,
        lastEditedBy: note.lastEditedBy,
        driveFileId: note.driveFileId,
        isShared: note.isShared,
        collaborators: List<String>.from(note.collaborators),
        adminEmails: List<String>.from(note.adminEmails),
      );

  static IsarNoteDocument fromDto(NoteDto dto) => IsarNoteDocument()
    ..id = dto.id
    ..title = dto.title
    ..createdAt = dto.createdAt
    ..updatedAt = dto.updatedAt
    ..dashboardX = dto.dashboardX
    ..dashboardY = dto.dashboardY
    ..isPinned = dto.isPinned
    ..parentFolderId = dto.parentFolderId
    ..isDeleted = dto.isDeleted
    ..excludeFromBackup = dto.excludeFromBackup
    ..deletedAt = dto.deletedAt
    ..tags = List<String>.from(dto.tags)
    ..pages = dto.pages.map(_pageFromDto).cast<IsarNotePage>().toList()
    ..ownerEmail = dto.ownerEmail
    ..lastEditedBy = dto.lastEditedBy
    ..driveFileId = dto.driveFileId
    ..isShared = dto.isShared
    ..collaborators = List<String>.from(dto.collaborators)
    ..adminEmails = List<String>.from(dto.adminEmails);

  // Page
  static NotePageDto _pageToDto(IsarNotePage page) => NotePageDto(
        id: page.id!,
        width: page.width,
        height: page.height,
        blocks: page.blocks.map(_blockToDto).cast<NoteBlockDto>().toList(),
      );

  static IsarNotePage _pageFromDto(NotePageDto dto) => IsarNotePage()
    ..id = dto.id
    ..width = dto.width
    ..height = dto.height
    ..blocks = dto.blocks.map(_blockFromDto).cast<IsarNoteBlock>().toList();

  // Block
  static NoteBlockDto _blockToDto(IsarNoteBlock block) => NoteBlockDto(
        id: block.id!,
        type: block.type ?? 'text',
        x: block.x,
        y: block.y,
        width: block.width,
        height: block.height,
        rotation: block.rotation,
        opacity: block.opacity,
        textContent: block.textContent != null
            ? _richTextToDto(block.textContent!)
            : null,
        strokes: block.strokes.map(_strokeToDto).cast<StrokeDto>().toList(),
      );

  static IsarNoteBlock _blockFromDto(NoteBlockDto dto) => IsarNoteBlock()
    ..id = dto.id
    ..type = dto.type
    ..x = dto.x
    ..y = dto.y
    ..width = dto.width
    ..height = dto.height
    ..rotation = dto.rotation
    ..opacity = dto.opacity
    ..textContent =
        dto.textContent != null ? _richTextFromDto(dto.textContent!) : null
    ..strokes = dto.strokes.map(_strokeFromDto).toList();

  // Rich text
  static RichTextDto _richTextToDto(IsarRichTextContent rt) => RichTextDto(
        segments: rt.segments.map(_segmentToDto).cast<TextSegmentDto>().toList(),
      );

  static IsarRichTextContent _richTextFromDto(RichTextDto dto) =>
      IsarRichTextContent()
        ..segments = dto.segments.map(_segmentFromDto).cast<IsarTextSegment>().toList();

  static TextSegmentDto _segmentToDto(IsarTextSegment seg) => TextSegmentDto(
        text: seg.text,
        isBold: seg.isBold,
        isItalic: seg.isItalic,
        isHeading: seg.isHeading,
        fontSize: seg.fontSize,
        colorValue: seg.colorValue,
      );

  static IsarTextSegment _segmentFromDto(TextSegmentDto dto) =>
      IsarTextSegment()
        ..text = dto.text
        ..isBold = dto.isBold
        ..isItalic = dto.isItalic
        ..isHeading = dto.isHeading
        ..fontSize = dto.fontSize
        ..colorValue = dto.colorValue;

  // Stroke
  static StrokeDto _strokeToDto(IsarStroke stroke) => StrokeDto(
        colorValue: stroke.colorValue,
        width: stroke.width,
        pressures: List<double>.from(stroke.pressures),
        points: stroke.points
            .map((p) => PointDto(x: p.x, y: p.y))
            .cast<PointDto>()
            .toList(),
      );

  static IsarStroke _strokeFromDto(StrokeDto dto) => IsarStroke()
    ..colorValue = dto.colorValue
    ..width = dto.width
    ..pressures = List<double>.from(dto.pressures)
    ..points = dto.points
        .map((p) => IsarPoint()
          ..x = p.x
          ..y = p.y)
        .toList();
}

// ─── Folder ────────────────────────────────────────────────────────────────

class IsarFolderMapper {
  IsarFolderMapper._();

  static FolderDto toDto(IsarFolder folder) => FolderDto(
        id: folder.id!,
        name: folder.name,
        dashboardX: folder.dashboardX,
        dashboardY: folder.dashboardY,
        parentFolderId: folder.parentFolderId,
        isDeleted: folder.isDeleted,
        deletedAt: folder.deletedAt,
        isPinned: folder.isPinned,
        colorValue: folder.colorValue,
        iconCodePoint: folder.iconCodePoint,
        tags: List<String>.from(folder.tags),
        noteIds: List<String>.from(folder.noteIds),
        childFolderIds: List<String>.from(folder.childFolderIds),
        ownerEmail: folder.ownerEmail,
        driveFileId: folder.driveFileId,
        isShared: folder.isShared,
        collaborators: List<String>.from(folder.collaborators),
        adminEmails: List<String>.from(folder.adminEmails),
      );

  static IsarFolder fromDto(FolderDto dto) => IsarFolder()
    ..id = dto.id
    ..name = dto.name
    ..dashboardX = dto.dashboardX
    ..dashboardY = dto.dashboardY
    ..parentFolderId = dto.parentFolderId
    ..isDeleted = dto.isDeleted
    ..deletedAt = dto.deletedAt
    ..isPinned = dto.isPinned
    ..colorValue = dto.colorValue
    ..iconCodePoint = dto.iconCodePoint
    ..tags = List<String>.from(dto.tags)
    ..noteIds = List<String>.from(dto.noteIds)
    ..childFolderIds = List<String>.from(dto.childFolderIds)
    ..ownerEmail = dto.ownerEmail
    ..driveFileId = dto.driveFileId
    ..isShared = dto.isShared
    ..collaborators = List<String>.from(dto.collaborators)
    ..adminEmails = List<String>.from(dto.adminEmails);
}

// ─── Tag ───────────────────────────────────────────────────────────────────

class IsarTagMapper {
  IsarTagMapper._();

  static TagDto toDto(IsarTag tag) => TagDto(
        id: tag.id!,
        name: tag.name,
        colorValue: tag.colorValue,
      );

  static IsarTag fromDto(TagDto dto) => IsarTag()
    ..id = dto.id
    ..name = dto.name
    ..colorValue = dto.colorValue;
}
