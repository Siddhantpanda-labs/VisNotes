/// Public barrel file for the VisNotes serialization layer.
///
/// Import this single file to access all serialization components:
///
/// ```dart
/// import 'package:visnotes/features/notes/data/serialization/note_serialization.dart';
/// ```
library note_serialization;

// DTOs — canonical portable data format
export 'dto/note_dto.dart';

// Mappers — Isar ↔ DTO translation
export 'mappers/isar_note_mapper.dart';

// Exporters — abstract interface + concrete implementations
export 'exporters/note_exporter.dart';
export 'exporters/drive_json_exporter.dart';
export 'exporters/pdf_exporter.dart';
