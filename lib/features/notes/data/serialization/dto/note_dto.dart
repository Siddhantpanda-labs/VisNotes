/// Data Transfer Objects (DTOs) for VisNotes serialization.
///
/// These are pure Dart classes that act as the canonical representation
/// of note data for ALL export formats (JSON, PDF, native .visnote, etc.).
/// They are intentionally decoupled from both Isar storage models and
/// Flutter domain entities — this keeps the serialization layer independently
/// testable and portable.
library note_dto;

// ─── Snapshot ──────────────────────────────────────────────────────────────

/// The top-level container for a complete VisNotes data export.
class NoteSnapshotDto {
  final int version;
  final DateTime exportedAt;
  final String? exportedByEmail;
  final List<NoteDto> notes;
  final List<FolderDto> folders;
  final List<TagDto> tags;

  const NoteSnapshotDto({
    required this.version,
    required this.exportedAt,
    this.exportedByEmail,
    required this.notes,
    required this.folders,
    required this.tags,
  });

  Map<String, dynamic> toJson() => {
        'version': version,
        'exportedAt': exportedAt.toIso8601String(),
        'exportedByEmail': exportedByEmail,
        'notes': notes.map((n) => n.toJson()).toList(),
        'folders': folders.map((f) => f.toJson()).toList(),
        'tags': tags.map((t) => t.toJson()).toList(),
      };

  factory NoteSnapshotDto.fromJson(Map<String, dynamic> json) =>
      NoteSnapshotDto(
        version: json['version'] as int? ?? 1,
        exportedAt: DateTime.parse(json['exportedAt'] as String),
        exportedByEmail: json['exportedByEmail'] as String?,
        notes: (json['notes'] as List? ?? [])
            .map((e) => NoteDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        folders: (json['folders'] as List? ?? [])
            .map((e) => FolderDto.fromJson(e as Map<String, dynamic>))
            .toList(),
        tags: (json['tags'] as List? ?? [])
            .map((e) => TagDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Note ──────────────────────────────────────────────────────────────────

class NoteDto {
  final String id;
  final String? title;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final double dashboardX;
  final double dashboardY;
  final bool isPinned;
  final String? parentFolderId;
  final bool isDeleted;
  final bool excludeFromBackup;
  final DateTime? deletedAt;
  final List<String> tags;
  final List<NotePageDto> pages;

  const NoteDto({
    required this.id,
    this.title,
    this.createdAt,
    this.updatedAt,
    this.dashboardX = 0,
    this.dashboardY = 0,
    this.isPinned = false,
    this.parentFolderId,
    this.isDeleted = false,
    this.excludeFromBackup = false,
    this.deletedAt,
    this.tags = const [],
    this.pages = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'dashboardX': dashboardX,
        'dashboardY': dashboardY,
        'isPinned': isPinned,
        'parentFolderId': parentFolderId,
        'isDeleted': isDeleted,
        'excludeFromBackup': excludeFromBackup,
        'deletedAt': deletedAt?.toIso8601String(),
        'tags': tags,
        'pages': pages.map((p) => p.toJson()).toList(),
      };

  factory NoteDto.fromJson(Map<String, dynamic> json) => NoteDto(
        id: json['id'] as String,
        title: json['title'] as String?,
        createdAt: _parseDate(json['createdAt']),
        updatedAt: _parseDate(json['updatedAt']),
        dashboardX: _toDouble(json['dashboardX']),
        dashboardY: _toDouble(json['dashboardY']),
        isPinned: json['isPinned'] as bool? ?? false,
        parentFolderId: json['parentFolderId'] as String?,
        isDeleted: json['isDeleted'] as bool? ?? false,
        excludeFromBackup: json['excludeFromBackup'] as bool? ?? false,
        deletedAt: _parseDate(json['deletedAt']),
        tags: List<String>.from(json['tags'] as List? ?? []),
        pages: (json['pages'] as List? ?? [])
            .map((e) => NotePageDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Page ──────────────────────────────────────────────────────────────────

class NotePageDto {
  final String id;
  final double width;
  final double height;
  final List<NoteBlockDto> blocks;

  const NotePageDto({
    required this.id,
    this.width = 792.0,
    this.height = 1056.0,
    this.blocks = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'width': width,
        'height': height,
        'blocks': blocks.map((b) => b.toJson()).toList(),
      };

  factory NotePageDto.fromJson(Map<String, dynamic> json) => NotePageDto(
        id: json['id'] as String,
        width: _toDouble(json['width'], fallback: 792.0),
        height: _toDouble(json['height'], fallback: 1056.0),
        blocks: (json['blocks'] as List? ?? [])
            .map((e) => NoteBlockDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Block ─────────────────────────────────────────────────────────────────

class NoteBlockDto {
  final String id;
  final String type; // 'text' | 'canvas'
  final double x;
  final double y;
  final double width;
  final double height;
  final double rotation;
  final double opacity;
  // Text block
  final RichTextDto? textContent;
  // Canvas block
  final List<StrokeDto> strokes;

  const NoteBlockDto({
    required this.id,
    required this.type,
    this.x = 0,
    this.y = 0,
    this.width = 0,
    this.height = 0,
    this.rotation = 0,
    this.opacity = 1.0,
    this.textContent,
    this.strokes = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'x': x,
        'y': y,
        'width': width,
        'height': height,
        'rotation': rotation,
        'opacity': opacity,
        if (textContent != null) 'textContent': textContent!.toJson(),
        if (strokes.isNotEmpty) 'strokes': strokes.map((s) => s.toJson()).toList(),
      };

  factory NoteBlockDto.fromJson(Map<String, dynamic> json) => NoteBlockDto(
        id: json['id'] as String,
        type: json['type'] as String? ?? 'text',
        x: _toDouble(json['x']),
        y: _toDouble(json['y']),
        width: _toDouble(json['width']),
        height: _toDouble(json['height']),
        rotation: _toDouble(json['rotation']),
        opacity: _toDouble(json['opacity'], fallback: 1.0),
        textContent: json['textContent'] != null
            ? RichTextDto.fromJson(json['textContent'] as Map<String, dynamic>)
            : null,
        strokes: (json['strokes'] as List? ?? [])
            .map((e) => StrokeDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

// ─── Rich Text ─────────────────────────────────────────────────────────────

class RichTextDto {
  final List<TextSegmentDto> segments;
  const RichTextDto({required this.segments});

  Map<String, dynamic> toJson() => {
        'segments': segments.map((s) => s.toJson()).toList(),
      };

  factory RichTextDto.fromJson(Map<String, dynamic> json) => RichTextDto(
        segments: (json['segments'] as List? ?? [])
            .map((e) => TextSegmentDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class TextSegmentDto {
  final String? text;
  final bool isBold;
  final bool isItalic;
  final bool isHeading;
  final double fontSize;
  final int colorValue;

  const TextSegmentDto({
    this.text,
    this.isBold = false,
    this.isItalic = false,
    this.isHeading = false,
    this.fontSize = 16.0,
    this.colorValue = 0xFF000000,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'isBold': isBold,
        'isItalic': isItalic,
        'isHeading': isHeading,
        'fontSize': fontSize,
        'colorValue': colorValue,
      };

  factory TextSegmentDto.fromJson(Map<String, dynamic> json) => TextSegmentDto(
        text: json['text'] as String?,
        isBold: json['isBold'] as bool? ?? false,
        isItalic: json['isItalic'] as bool? ?? false,
        isHeading: json['isHeading'] as bool? ?? false,
        fontSize: _toDouble(json['fontSize'], fallback: 16.0),
        colorValue: json['colorValue'] as int? ?? 0xFF000000,
      );
}

// ─── Stroke ────────────────────────────────────────────────────────────────

class StrokeDto {
  final int colorValue;
  final double width;
  final List<double> pressures;
  final List<PointDto> points;

  const StrokeDto({
    required this.colorValue,
    required this.width,
    required this.pressures,
    required this.points,
  });

  Map<String, dynamic> toJson() => {
        'colorValue': colorValue,
        'width': width,
        'pressures': pressures,
        'points': points.map((p) => p.toJson()).toList(),
      };

  factory StrokeDto.fromJson(Map<String, dynamic> json) => StrokeDto(
        colorValue: json['colorValue'] as int? ?? 0xFF000000,
        width: _toDouble(json['width'], fallback: 2.0),
        pressures: List<double>.from(
            (json['pressures'] as List? ?? []).map((p) => _toDouble(p))),
        points: (json['points'] as List? ?? [])
            .map((e) => PointDto.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}

class PointDto {
  final double x;
  final double y;
  const PointDto({required this.x, required this.y});

  Map<String, dynamic> toJson() => {'x': x, 'y': y};
  factory PointDto.fromJson(Map<String, dynamic> json) =>
      PointDto(x: _toDouble(json['x']), y: _toDouble(json['y']));
}

// ─── Folder ────────────────────────────────────────────────────────────────

class FolderDto {
  final String id;
  final String? name;
  final double dashboardX;
  final double dashboardY;
  final String? parentFolderId;
  final bool isDeleted;
  final DateTime? deletedAt;
  final bool isPinned;
  final int? colorValue;
  final int? iconCodePoint;
  final List<String> tags;
  final List<String> noteIds;
  final List<String> childFolderIds;

  const FolderDto({
    required this.id,
    this.name,
    this.dashboardX = 0,
    this.dashboardY = 0,
    this.parentFolderId,
    this.isDeleted = false,
    this.deletedAt,
    this.isPinned = false,
    this.colorValue,
    this.iconCodePoint,
    this.tags = const [],
    this.noteIds = const [],
    this.childFolderIds = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dashboardX': dashboardX,
        'dashboardY': dashboardY,
        'parentFolderId': parentFolderId,
        'isDeleted': isDeleted,
        'deletedAt': deletedAt?.toIso8601String(),
        'isPinned': isPinned,
        'colorValue': colorValue,
        'iconCodePoint': iconCodePoint,
        'tags': tags,
        'noteIds': noteIds,
        'childFolderIds': childFolderIds,
      };

  factory FolderDto.fromJson(Map<String, dynamic> json) => FolderDto(
        id: json['id'] as String,
        name: json['name'] as String?,
        dashboardX: _toDouble(json['dashboardX']),
        dashboardY: _toDouble(json['dashboardY']),
        parentFolderId: json['parentFolderId'] as String?,
        isDeleted: json['isDeleted'] as bool? ?? false,
        deletedAt: _parseDate(json['deletedAt']),
        isPinned: json['isPinned'] as bool? ?? false,
        colorValue: json['colorValue'] as int?,
        iconCodePoint: json['iconCodePoint'] as int?,
        tags: List<String>.from(json['tags'] as List? ?? []),
        noteIds: List<String>.from(json['noteIds'] as List? ?? []),
        childFolderIds:
            List<String>.from(json['childFolderIds'] as List? ?? []),
      );
}

// ─── Tag ───────────────────────────────────────────────────────────────────

class TagDto {
  final String id;
  final String? name;
  final int colorValue;

  const TagDto({
    required this.id,
    this.name,
    this.colorValue = 0xFF2196F3,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'colorValue': colorValue,
      };

  factory TagDto.fromJson(Map<String, dynamic> json) => TagDto(
        id: json['id'] as String,
        name: json['name'] as String?,
        colorValue: json['colorValue'] as int? ?? 0xFF2196F3,
      );
}

// ─── Helpers ───────────────────────────────────────────────────────────────

double _toDouble(dynamic value, {double fallback = 0.0}) {
  if (value == null) return fallback;
  if (value is double) return value;
  if (value is int) return value.toDouble();
  if (value is num) return value.toDouble();
  return fallback;
}

DateTime? _parseDate(dynamic value) {
  if (value == null) return null;
  try {
    return DateTime.parse(value as String);
  } catch (_) {
    return null;
  }
}
