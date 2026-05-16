/// PDF exporter for VisNotes.
///
/// Exports individual notes or collections as formatted PDF documents.
/// Each note page becomes a PDF page, preserving layout, typography, and
/// (as a rasterized image) canvas/ink strokes.
///
/// Status: Stub — interface and architecture are finalized.
///         Rendering implementation pending `pdf` package integration.
library pdf_exporter;

import '../dto/note_dto.dart';
import 'note_exporter.dart';

/// Options specific to PDF export.
class PdfExportOptions extends ExportOptions {
  /// Page size preset.
  final PdfPageSize pageSize;

  /// Whether to include a cover page with the note title and metadata.
  final bool includeCoverPage;

  /// Whether to embed font metadata for accessibility.
  final bool embedFonts;

  const PdfExportOptions({
    super.noteIds,
    super.folderIds,
    super.includeDeleted,
    super.exportedByEmail,
    this.pageSize = PdfPageSize.a4,
    this.includeCoverPage = true,
    this.embedFonts = true,
  });
}

enum PdfPageSize { a4, letter, a3 }

/// Exports a [NoteSnapshotDto] to one or more PDF files.
///
/// One PDF is generated per note. If exporting a folder, all notes
/// within the folder are exported as individual files and returned
/// as a zip archive.
class PdfExporter implements NoteExporter {
  /// Directory where exported PDFs will be saved.
  final String outputDirectory;

  const PdfExporter({required this.outputDirectory});

  @override
  String get name => 'PDF';

  @override
  String get fileExtension => 'pdf';

  @override
  Future<ExportResult> export(
    NoteSnapshotDto snapshot, {
    ExportOptions options = ExportOptions.full,
  }) async {
    // TODO: Implement with `pdf` package (pub.dev/packages/pdf).
    //
    // Implementation plan:
    // 1. For each NoteDto in snapshot.notes:
    //    a. Create a pw.Document()
    //    b. For each NotePageDto:
    //       - Add a pw.Page with the correct width/height (pt units)
    //       - For each NoteBlockDto:
    //           * If type == 'text': render pw.RichText from TextSegmentDtos
    //           * If type == 'canvas': rasterize strokes to a pw.Image
    //    c. Save to '$outputDirectory/${note.title ?? note.id}.pdf'
    // 2. If multiple notes, zip and return zip path.
    //
    // Packages needed:
    //   pdf: ^3.10.0
    //   printing: ^5.12.0
    //
    // Add to pubspec.yaml when implementing:
    //   pdf: ^3.10.0

    throw UnimplementedError(
      'PDF export is not yet implemented. '
      'Add the `pdf` package and implement rendering in '
      'lib/features/notes/data/serialization/exporters/pdf_exporter.dart',
    );
  }

  // ─── Private Rendering Helpers (stubs) ───────────────────────────────────

  // Future<Uint8List> _renderNote(NoteDto note, PdfExportOptions opts) async { ... }
  // Future<pw.Widget> _renderTextBlock(NoteBlockDto block) async { ... }
  // Future<pw.Widget> _renderCanvasBlock(NoteBlockDto block) async { ... }
}
