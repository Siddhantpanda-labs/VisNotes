/// Google Drive JSON exporter.
///
/// Implements [NoteExporter] and [NoteImporter] for the cloud sync use case.
/// Serializes a [NoteSnapshotDto] to JSON and uploads/downloads it as
/// `visnotes_sync_data.json` in the user's Google Drive (appDataFolder scope
/// or drive.file scope, per app configuration).
library drive_json_exporter;

import 'dart:convert';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import '../dto/note_dto.dart';
import 'note_exporter.dart';

class DriveJsonExporter implements NoteExporter, NoteImporter {
  final AuthClient authClient;

  static const String _fileName = 'visnotes_sync_data.json';
  static const String _mimeType = 'application/json';

  const DriveJsonExporter({required this.authClient});

  @override
  String get name => 'Google Drive JSON';

  @override
  String get fileExtension => 'json';

  // ─── Export ──────────────────────────────────────────────────────────────

  @override
  Future<ExportResult> export(
    NoteSnapshotDto snapshot, {
    ExportOptions options = ExportOptions.full,
  }) async {
    try {
      final driveApi = drive.DriveApi(authClient);

      final content = jsonEncode(snapshot.toJson());
      final bytes   = utf8.encode(content);
      final media   = drive.Media(
        Stream.value(bytes),
        bytes.length,
        contentType: _mimeType,
      );

      final existingId = await _findFileId(driveApi);

      if (existingId != null) {
        await driveApi.files.update(
          drive.File()..name = _fileName,
          existingId,
          uploadMedia: media,
        );
        return ExportResult.ok(message: 'Sync updated on Google Drive.');
      } else {
        final created = await driveApi.files.create(
          drive.File()
            ..name = _fileName
            ..mimeType = _mimeType,
          uploadMedia: media,
        );
        return ExportResult.ok(
          message: 'Sync file created on Google Drive.',
          outputPath: created.id,
        );
      }
    } catch (e) {
      return ExportResult.err(message: 'Drive sync failed: $e');
    }
  }

  // ─── Import ──────────────────────────────────────────────────────────────

  @override
  Future<NoteSnapshotDto?> importSnapshot() async {
    try {
      final driveApi = drive.DriveApi(authClient);
      final fileId   = await _findFileId(driveApi);
      if (fileId == null) return null;

      final media = await driveApi.files.get(
        fileId,
        downloadOptions: drive.DownloadOptions.fullMedia,
      ) as drive.Media;

      final chunks  = await media.stream.toList();
      final content = utf8.decode(chunks.expand((c) => c).toList());
      return NoteSnapshotDto.fromJson(
          jsonDecode(content) as Map<String, dynamic>);
    } catch (e) {
      throw Exception('Drive restore failed: $e');
    }
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  Future<String?> _findFileId(drive.DriveApi driveApi) async {
    final list = await driveApi.files.list(
      q: "name = '$_fileName' and trashed = false",
      spaces: 'drive',
      $fields: 'files(id)',
    );
    return list.files?.isNotEmpty == true ? list.files!.first.id : null;
  }
}
