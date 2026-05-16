/// Abstract contract for all VisNotes export formats.
///
/// Every exporter (JSON, PDF, native .visnote) must implement this interface.
/// The [NoteExporter] abstraction allows the rest of the app to trigger an
/// export without knowing anything about the output format.
library note_exporter;

import '../dto/note_dto.dart';

/// The result of an export operation.
class ExportResult {
  /// Whether the export succeeded.
  final bool success;

  /// A human-readable message (e.g., "Synced to Google Drive" or error text).
  final String message;

  /// Optional: the output file path or URL, if applicable.
  final String? outputPath;

  const ExportResult({
    required this.success,
    required this.message,
    this.outputPath,
  });

  factory ExportResult.ok({required String message, String? outputPath}) =>
      ExportResult(success: true, message: message, outputPath: outputPath);

  factory ExportResult.err({required String message}) =>
      ExportResult(success: false, message: message);

  @override
  String toString() => 'ExportResult(success: $success, message: $message)';
}

/// The options passed to an export operation.
class ExportOptions {
  /// If true, only export notes that belong to [folderIds].
  final List<String>? folderIds;

  /// If true, only export notes with these IDs.
  final List<String>? noteIds;

  /// If true, include deleted (trashed) notes in the export.
  final bool includeDeleted;

  /// Optional metadata to embed in the export header.
  final String? exportedByEmail;

  const ExportOptions({
    this.folderIds,
    this.noteIds,
    this.includeDeleted = false,
    this.exportedByEmail,
  });

  /// Default options: export everything, no filter.
  static const ExportOptions full = ExportOptions();
}

/// Abstract base class for all export formats.
///
/// Implement this to add a new export target (PDF, Drive JSON, .visnote, etc.).
abstract class NoteExporter {
  /// A human-readable name for this export format (e.g., "Google Drive JSON").
  String get name;

  /// The file extension this exporter produces (e.g., "json", "pdf").
  String get fileExtension;

  /// Export a snapshot of notes/folders/tags.
  ///
  /// Implementations should handle their own I/O (file write, network call, etc.)
  /// and return an [ExportResult] indicating success or failure.
  Future<ExportResult> export(
    NoteSnapshotDto snapshot, {
    ExportOptions options = ExportOptions.full,
  });
}

/// Abstract base class for importers that can also restore data.
abstract class NoteImporter {
  /// Import a snapshot from an external source.
  ///
  /// Returns `null` if no data was found (e.g., no backup file on Drive).
  Future<NoteSnapshotDto?> importSnapshot();
}
