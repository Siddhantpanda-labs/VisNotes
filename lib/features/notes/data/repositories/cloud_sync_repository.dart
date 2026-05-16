/// Cloud Sync Repository.
///
/// Responsible for Google OAuth2 authentication and orchestrating data sync
/// to/from Google Drive. All serialization is delegated to the dedicated
/// serialization layer — this class contains zero JSON structure knowledge.
library cloud_sync_repository;

import 'dart:convert' show jsonDecode;
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;

import '../models/isar_note_model.dart';
import 'note_repository.dart';
import '../serialization/note_serialization.dart';

// ─── Domain Model ──────────────────────────────────────────────────────────

/// Authenticated Google user profile returned after OAuth2.
class CloudUser {
  final String email;
  final String name;
  final String? photoUrl;
  final AccessCredentials credentials;
  
  const CloudUser(this.email, this.name, this.photoUrl, this.credentials);
}

// ─── Repository ────────────────────────────────────────────────────────────

class CloudSyncRepository {
  final NoteRepository noteRepository;

  static const List<String> _scopes = [
    drive.DriveApi.driveFileScope,
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  // IMPORTANT: Move these to environment config / secrets manager before production.
  final ClientId _clientId = ClientId(
    'YOUR_CLIENT_ID_HERE',
    'YOUR_CLIENT_SECRET_HERE',
  );

  AuthClient? _authClient;

  CloudSyncRepository(this.noteRepository);

  // ─── Auth ────────────────────────────────────────────────────────────────

  /// Restores an existing session from saved credentials.
  void restoreSession(AccessCredentials credentials) {
    _authClient = authenticatedClient(http.Client(), credentials);
    print('[CloudSync] Session restored for existing credentials.');
  }

  Future<CloudUser?> signIn() async {
    try {
      _authClient =
          await clientViaUserConsent(_clientId, _scopes, (url) async {
        if (!await launchUrl(Uri.parse(url))) {
          throw Exception('Could not launch OAuth URL: $url');
        }
      });

      if (_authClient == null) return null;

      final response = await _authClient!.get(
        Uri.parse('https://www.googleapis.com/oauth2/v1/userinfo?alt=json'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        return CloudUser(
          data['email'] as String? ?? '',
          data['name'] as String? ?? 'Google User',
          data['picture'] as String?,
          _authClient!.credentials,
        );
      }
      return null;
    } catch (e) {
      print('[CloudSync] Sign in failed: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    _authClient?.close();
    _authClient = null;
  }

  bool get isAuthenticated => _authClient != null;

  // ─── Sync To Drive ───────────────────────────────────────────────────────

  /// Uploads the full note snapshot to Google Drive.
  /// Throws [StateError] if not authenticated.
  Future<ExportResult> syncToDrive(String? email) async {
    _assertAuthenticated();

    final snapshot = await _buildSnapshot(exportedByEmail: email);
    final exporter = DriveJsonExporter(authClient: _authClient!);
    final result   = await exporter.export(snapshot);

    if (!result.success) {
      print('[CloudSync] Sync error: ${result.message}');
    }
    return result;
  }

  // ─── Restore From Drive ──────────────────────────────────────────────────

  /// Downloads the latest backup from Drive and writes it to local Isar.
  /// Returns `false` if no backup file exists.
  Future<bool> restoreFromDrive() async {
    _assertAuthenticated();

    final importer = DriveJsonExporter(authClient: _authClient!);
    final snapshot = await importer.importSnapshot();
    if (snapshot == null) return false;

    await _applySnapshot(snapshot);
    return true;
  }

  // ─── Snapshot Helpers ────────────────────────────────────────────────────

  /// Reads all data from Isar and maps it to a portable [NoteSnapshotDto].
  Future<NoteSnapshotDto> _buildSnapshot({String? exportedByEmail}) async {
    final notes   = await noteRepository.getAllNotes();
    final folders = await noteRepository.getAllFolders();
    final tags    = await noteRepository.getAllTags();

    final snapshotNotes = notes
        .where((n) => !n.excludeFromBackup)
        .map(IsarNoteMapper.toDto)
        .cast<NoteDto>()
        .toList();

    return NoteSnapshotDto(
      version: 1,
      exportedAt: DateTime.now(),
      exportedByEmail: exportedByEmail,
      notes:   snapshotNotes,
      folders: folders.map(IsarFolderMapper.toDto).cast<FolderDto>().toList(),
      tags:    tags.map(IsarTagMapper.toDto).cast<TagDto>().toList(),
    );
  }

  /// Writes a [NoteSnapshotDto] back to Isar.
  Future<void> _applySnapshot(NoteSnapshotDto snapshot) async {
    for (final dto in snapshot.notes) {
      await noteRepository.saveNote(IsarNoteMapper.fromDto(dto));
    }
    for (final dto in snapshot.folders) {
      await noteRepository.saveFolder(IsarFolderMapper.fromDto(dto));
    }
    for (final dto in snapshot.tags) {
      await noteRepository.saveTag(IsarTagMapper.fromDto(dto));
    }
  }

  // ─── Internal ────────────────────────────────────────────────────────────

  void _assertAuthenticated() {
    if (_authClient == null) {
      throw StateError(
        '[CloudSyncRepository] Not authenticated. Call signIn() first.',
      );
    }
  }
}
