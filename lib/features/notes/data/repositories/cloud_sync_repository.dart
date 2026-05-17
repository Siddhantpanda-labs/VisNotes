/// Cloud Sync Repository.
///
/// Responsible for Google OAuth2 authentication and orchestrating data sync
/// to/from Google Drive. All serialization is delegated to the dedicated
/// serialization layer — this class contains zero JSON structure knowledge.
library cloud_sync_repository;

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:isar/isar.dart';

import '../models/isar_note_model.dart';
import 'note_repository.dart';
import '../serialization/note_serialization.dart';
import '../../domain/entities/collaborator_profile.dart';

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
    drive.DriveApi.driveScope,   // Full drive — required for sharedWithMe queries
    'https://www.googleapis.com/auth/userinfo.email',
    'https://www.googleapis.com/auth/userinfo.profile',
  ];

  final ClientId _clientId = ClientId(
    dotenv.env['GOOGLE_CLIENT_ID'] ?? '',
    dotenv.env['GOOGLE_CLIENT_SECRET'] ?? '',
  );

  AuthClient? _authClient;
  bool _isOperationInProgress = false;

  CloudSyncRepository(this.noteRepository);

  /// Returns an authenticated client, refreshing it if necessary.
  Future<drive.DriveApi> _getDriveApi() async {
    _assertAuthenticated();
    await _refreshIfExpired();
    return drive.DriveApi(_authClient!);
  }

  Future<void> _refreshIfExpired() async {
    if (_authClient == null) return;
    
    final settings = await noteRepository.getUserSettings();
    if (settings == null || settings.googleRefreshToken == null) return;

    // Check if token is expired (with 5 minute buffer)
    final now = DateTime.now().toUtc();
    if (settings.googleTokenExpiry != null && settings.googleTokenExpiry!.toUtc().isAfter(now.add(const Duration(minutes: 5)))) {
      return;
    }

    print('[CloudSync] Token expired or near expiry. Refreshing...');
    try {
      final newCredentials = await refreshCredentials(_clientId, _authClient!.credentials, http.Client());
      
      // Update local state
      _authClient = authenticatedClient(http.Client(), newCredentials);
      
      // Update database
      settings.googleAccessToken = newCredentials.accessToken.data;
      settings.googleTokenExpiry = newCredentials.accessToken.expiry;
      if (newCredentials.refreshToken != null) {
        settings.googleRefreshToken = newCredentials.refreshToken;
      }
      await noteRepository.saveUserSettings(settings);
      print('[CloudSync] Token refreshed successfully.');
    } catch (e) {
      print('[CloudSync] Token refresh failed: $e');
      // If refresh fails, we might need to force re-login eventually, 
      // but for now we just log it.
    }
  }

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

  /// Syncs the entire local database to Google Drive (Legacy Global Sync).
  Future<ExportResult> syncToDrive(String? email) async {
    if (_isOperationInProgress) return ExportResult.err(message: 'Operation already in progress');
    _isOperationInProgress = true;
    try {
      final driveApi = await _getDriveApi(); // Handles refresh
      final snapshot = await _buildSnapshot(exportedByEmail: email);
      final exporter = DriveJsonExporter(authClient: _authClient!);
      final result   = await exporter.export(snapshot);

      if (!result.success) {
        print('[CloudSync] Sync error: ${result.message}');
      }
      _isOperationInProgress = false;
      return result;
    } catch (e) {
      _isOperationInProgress = false;
      print('[CloudSync] Sync failed: $e');
      return ExportResult.err(message: e.toString());
    }
  }

  // ─── Restore From Drive ──────────────────────────────────────────────────

  /// Restores the entire database from the global sync file on Google Drive.
  Future<bool> restoreFromDrive() async {
    if (_isOperationInProgress) return false;
    _isOperationInProgress = true;
    try {
      final driveApi = await _getDriveApi(); // Handles refresh
      final importer = DriveJsonExporter(authClient: _authClient!);
      final snapshot = await importer.importSnapshot();
      if (snapshot == null) {
        _isOperationInProgress = false;
        return false;
      }

      await _applySnapshot(snapshot);
      _isOperationInProgress = false;
      return true;
    } catch (e) {
      _isOperationInProgress = false;
      print('[CloudSync] Restore failed: $e');
      return false;
    }
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

  // ─── Collaboration ───────────────────────────────────────────────────────

  static const String _visNotesFolderName = 'VisNotes';
  static const String _sharedFolderName   = 'Shared';

  /// Gets or creates the root "VisNotes/" folder in the user's Drive.
  Future<String?> _getOrCreateVisNotesRoot() async {
    final driveApi = await _getDriveApi();
    final settings = await noteRepository.getUserSettings();

    // Verify cached ID still exists in Drive
    final s1 = settings;
    if (s1 != null && s1.visNotesFolderId != null) {
      try {
        await driveApi.files.get(s1.visNotesFolderId!, $fields: 'id');
        return s1.visNotesFolderId;
      } catch (_) {
        // Stale — clear it and fall through to re-create
        s1.visNotesFolderId = null;
        await noteRepository.saveUserSettings(s1);
      }
    }

    final list = await driveApi.files.list(
      q: "name = '$_visNotesFolderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false and 'root' in parents",
      $fields: 'files(id)',
    );

    String? folderId;
    if (list.files?.isNotEmpty == true) {
      folderId = list.files!.first.id;
    } else {
      final created = await driveApi.files.create(
        drive.File()
          ..name = _visNotesFolderName
          ..mimeType = 'application/vnd.google-apps.folder',
      );
      folderId = created.id;
    }

    final fresh = await noteRepository.getUserSettings();
    if (fresh != null && folderId != null) {
      fresh.visNotesFolderId = folderId;
      await noteRepository.saveUserSettings(fresh);
    }
    return folderId;
  }

  /// Gets or creates the "VisNotes/Shared/" subfolder.
  Future<String?> _getOrCreateSharedFolder() async {
    // First ensure the root VisNotes/ folder exists
    final rootId = await _getOrCreateVisNotesRoot();
    if (rootId == null) return null;

    // Re-fetch settings AFTER root creation (root may have updated settings)
    final settings = await noteRepository.getUserSettings();

    // Verify cached shared folder ID still exists in Drive
    final s2 = settings;
    if (s2 != null && s2.sharedRootFolderId != null) {
      final driveApi = await _getDriveApi();
      try {
        await driveApi.files.get(s2.sharedRootFolderId!, $fields: 'id');
        return s2.sharedRootFolderId;
      } catch (_) {
        // Stale — clear it and fall through to re-create
        s2.sharedRootFolderId = null;
        await noteRepository.saveUserSettings(s2);
      }
    }

    final driveApi = await _getDriveApi();
    final list = await driveApi.files.list(
      q: "name = '$_sharedFolderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false and '$rootId' in parents",
      $fields: 'files(id)',
    );

    String? folderId;
    if (list.files?.isNotEmpty == true) {
      folderId = list.files!.first.id;
    } else {
      final created = await driveApi.files.create(
        drive.File()
          ..name = _sharedFolderName
          ..mimeType = 'application/vnd.google-apps.folder'
          ..parents = [rootId],
      );
      folderId = created.id;
    }

    final fresh = await noteRepository.getUserSettings();
    if (fresh != null && folderId != null) {
      fresh.sharedRootFolderId = folderId;
      await noteRepository.saveUserSettings(fresh);
    }
    return folderId;
  }

  // ─── Public Collaboration API ────────────────────────────────────────────

  /// Adds a collaborator to a note or folder by email.
  /// Uploads the item to Drive (if needed), grants write permission, and
  /// updates the local collaborators list.
  Future<CollaborationResult> addCollaborator({
    required String itemId,
    required bool isFolder,
    required String email,
    required String currentUserEmail,
  }) async {
    if (_isOperationInProgress) {
      return CollaborationFailure('Another operation is in progress.');
    }
    _isOperationInProgress = true;
    try {
      if (isFolder) {
        return await _addCollaboratorToFolder(itemId, email, currentUserEmail);
      } else {
        return await _addCollaboratorToNote(itemId, email, currentUserEmail);
      }
    } catch (e) {
      print('[CloudSync] addCollaborator failed: $e');
      return CollaborationFailure(e.toString());
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// Removes a collaborator from a note or folder.
  /// Revokes their Drive permission, updates the metadata on Drive,
  /// and removes them from the local lists.
  /// Only admins/owners can remove others.
  Future<CollaborationResult> removeCollaborator({
    required String itemId,
    required bool isFolder,
    required String emailToRemove,
    required String currentUserEmail,
  }) async {
    if (_isOperationInProgress) {
      return CollaborationFailure('Another operation is in progress.');
    }
    _isOperationInProgress = true;
    try {
      final item = isFolder
          ? await noteRepository.getFolderById(itemId)
          : await noteRepository.getNoteById(itemId);
      if (item == null) return CollaborationFailure('Item not found.');

      final driveFileId = isFolder
          ? (item as IsarFolder).driveFileId
          : (item as IsarNoteDocument).driveFileId;
      if (driveFileId == null) return CollaborationFailure('Item has no Drive file.');

      final currentCollaborators = List<String>.from(
          isFolder ? (item as IsarFolder).collaborators : (item as IsarNoteDocument).collaborators);
      final currentAdmins = List<String>.from(
          isFolder ? (item as IsarFolder).adminEmails : (item as IsarNoteDocument).adminEmails);
      final ownerEmail = (isFolder
          ? (item as IsarFolder).ownerEmail
          : (item as IsarNoteDocument).ownerEmail)?.trim().toLowerCase();
          
      final currentUserEmailLower = currentUserEmail.trim().toLowerCase();
      final emailToRemoveLower = emailToRemove.trim().toLowerCase();

      // If ownerEmail is null, it means this note originated locally and the current user is the owner.
      final isOwner = ownerEmail == null || ownerEmail == currentUserEmailLower;

      // Permission check: only owner or admins can remove others
      final isCurrentUserAdmin = currentAdmins.any((e) => e.trim().toLowerCase() == currentUserEmailLower) || isOwner;
      
      print('[CloudSync Debug] removeCollaborator:');
      print('  - currentUserEmail: $currentUserEmail ($currentUserEmailLower)');
      print('  - emailToRemove: $emailToRemove ($emailToRemoveLower)');
      print('  - ownerEmail: $ownerEmail');
      print('  - currentAdmins: $currentAdmins');
      print('  - isCurrentUserAdmin: $isCurrentUserAdmin');

      if (!isCurrentUserAdmin && emailToRemoveLower != currentUserEmailLower) {
        return CollaborationFailure('Only admins can remove collaborators.');
      }

      // Cannot remove the owner
      if (emailToRemoveLower == ownerEmail) {
        return CollaborationFailure('Cannot remove the owner. Transfer ownership first.');
      }

      // Revoke Drive permission
      await _revokePermission(driveFileId, emailToRemove);

      // Update local lists
      currentCollaborators.removeWhere((e) => e.trim().toLowerCase() == emailToRemoveLower);
      currentAdmins.removeWhere((e) => e.trim().toLowerCase() == emailToRemoveLower);

      if (isFolder) {
        await noteRepository.updateFolderCollaborators(itemId, currentCollaborators, currentAdmins);
        if (currentCollaborators.isEmpty) {
          await noteRepository.updateItemSharedStatus(itemId, true, isShared: false, driveFileId: driveFileId);
        }
      } else {
        await noteRepository.updateNoteCollaborators(itemId, currentCollaborators, currentAdmins);
        if (currentCollaborators.isEmpty) {
          await noteRepository.updateItemSharedStatus(itemId, false, isShared: false, driveFileId: driveFileId);
        }
      }

      // Sync updated metadata to Drive so the removed user sees the change
      await _syncCollaborationMetadata(itemId, isFolder);

      print('[CloudSync] Removed $emailToRemove from $itemId');
      return CollaborationSuccess();
    } catch (e) {
      print('[CloudSync] removeCollaborator failed: $e');
      return CollaborationFailure(e.toString());
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// Promotes or demotes a collaborator's admin status.
  /// Only the owner or another admin can call this.
  Future<CollaborationResult> setAdminStatus({
    required String itemId,
    required bool isFolder,
    required String targetEmail,
    required bool makeAdmin,
    required String currentUserEmail,
  }) async {
    if (_isOperationInProgress) {
      return CollaborationFailure('Another operation is in progress.');
    }
    _isOperationInProgress = true;
    try {
      final item = isFolder
          ? await noteRepository.getFolderById(itemId)
          : await noteRepository.getNoteById(itemId);
      if (item == null) return CollaborationFailure('Item not found.');

      final ownerEmail = (isFolder
          ? (item as IsarFolder).ownerEmail
          : (item as IsarNoteDocument).ownerEmail)?.trim().toLowerCase();
      final currentAdmins = List<String>.from(
          isFolder ? (item as IsarFolder).adminEmails : (item as IsarNoteDocument).adminEmails);
      final collaborators = List<String>.from(
          isFolder ? (item as IsarFolder).collaborators : (item as IsarNoteDocument).collaborators);

      final currentUserEmailLower = currentUserEmail.trim().toLowerCase();
      final targetEmailLower = targetEmail.trim().toLowerCase();

      // If ownerEmail is null, it means this note originated locally and the current user is the owner.
      final isOwner = ownerEmail == null || ownerEmail == currentUserEmailLower;

      final isCurrentUserAuthorized = isOwner || currentAdmins.any((e) => e.trim().toLowerCase() == currentUserEmailLower);
      if (!isCurrentUserAuthorized) {
        return CollaborationFailure('Only admins can change roles.');
      }
      if (targetEmailLower == ownerEmail) {
        return CollaborationFailure('Cannot change the owner\'s role.');
      }
      if (!collaborators.any((e) => e.trim().toLowerCase() == targetEmailLower)) {
        return CollaborationFailure('$targetEmail is not a collaborator.');
      }

      final isTargetAlreadyAdmin = currentAdmins.any((e) => e.trim().toLowerCase() == targetEmailLower);
      if (makeAdmin && !isTargetAlreadyAdmin) {
        currentAdmins.add(targetEmail);
      } else if (!makeAdmin) {
        currentAdmins.removeWhere((e) => e.trim().toLowerCase() == targetEmailLower);
      }

      if (isFolder) {
        await noteRepository.updateFolderCollaborators(itemId, collaborators, currentAdmins);
      } else {
        await noteRepository.updateNoteCollaborators(itemId, collaborators, currentAdmins);
      }
      await _syncCollaborationMetadata(itemId, isFolder);

      print('[CloudSync] Set admin=$makeAdmin for $targetEmail on $itemId');
      return CollaborationSuccess();
    } catch (e) {
      print('[CloudSync] setAdminStatus failed: $e');
      return CollaborationFailure(e.toString());
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// Transfers Drive ownership of an item to a collaborator.
  /// The target must already be a collaborator. On consumer Google accounts,
  /// the recipient must accept the transfer (Drive API limitation).
  Future<CollaborationResult> transferOwnership({
    required String itemId,
    required bool isFolder,
    required String newOwnerEmail,
    required String currentUserEmail,
  }) async {
    if (_isOperationInProgress) {
      return CollaborationFailure('Another operation is in progress.');
    }
    _isOperationInProgress = true;
    try {
      final item = isFolder
          ? await noteRepository.getFolderById(itemId)
          : await noteRepository.getNoteById(itemId);
      if (item == null) return CollaborationFailure('Item not found.');

      final ownerEmail = isFolder
          ? (item as IsarFolder).ownerEmail
          : (item as IsarNoteDocument).ownerEmail;
      // null ownerEmail means it was created locally — current user is the implicit owner
      final effectiveOwner = ownerEmail ?? currentUserEmail;
      if (effectiveOwner != currentUserEmail) {
        return CollaborationFailure('Only the owner can transfer ownership.');
      }

      final driveFileId = isFolder
          ? (item as IsarFolder).driveFileId
          : (item as IsarNoteDocument).driveFileId;
      if (driveFileId == null) return CollaborationFailure('Item has no Drive file.');

      final collaborators = List<String>.from(
          isFolder ? (item as IsarFolder).collaborators : (item as IsarNoteDocument).collaborators);
      if (!collaborators.contains(newOwnerEmail)) {
        return CollaborationFailure('$newOwnerEmail must be a collaborator first.');
      }

      // NOTE: Google Drive API does not allow programmatic ownership transfer on
      // consumer accounts (returns 403 "Consent required"). VisNotes treats
      // ownership as an app-level concept stored in the JSON metadata.
      // We simply update ownerEmail in the local DB and sync that to Drive —
      // both parties retain their existing Drive write permissions.

      // Update local metadata: new owner replaces old, old owner becomes collaborator
      collaborators.remove(newOwnerEmail);
      collaborators.add(currentUserEmail);

      final adminEmails = List<String>.from(
          isFolder ? (item as IsarFolder).adminEmails : (item as IsarNoteDocument).adminEmails);
      adminEmails.remove(newOwnerEmail);

      if (isFolder) {
        final folder = item as IsarFolder;
        folder.ownerEmail = newOwnerEmail;
        await noteRepository.saveFolder(folder);
        await noteRepository.updateFolderCollaborators(itemId, collaborators, adminEmails);
      } else {
        final note = item as IsarNoteDocument;
        note.ownerEmail = newOwnerEmail;
        await noteRepository.saveNote(note);
        await noteRepository.updateNoteCollaborators(itemId, collaborators, adminEmails);
      }
      await _syncCollaborationMetadata(itemId, isFolder);

      print('[CloudSync] Transferred ownership of $itemId to $newOwnerEmail');
      return CollaborationSuccess();
    } catch (e) {
      print('[CloudSync] transferOwnership failed: $e');
      return CollaborationFailure(e.toString());
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// The current user voluntarily leaves a collaboration.
  /// Revokes their own permission and deletes the item locally.
  Future<CollaborationResult> leaveCollaboration({
    required String itemId,
    required bool isFolder,
    required String currentUserEmail,
  }) async {
    if (_isOperationInProgress) {
      return CollaborationFailure('Another operation is in progress.');
    }
    _isOperationInProgress = true;
    try {
      final item = isFolder
          ? await noteRepository.getFolderById(itemId)
          : await noteRepository.getNoteById(itemId);
      if (item == null) return CollaborationFailure('Item not found.');

      final ownerEmail = isFolder
          ? (item as IsarFolder).ownerEmail
          : (item as IsarNoteDocument).ownerEmail;

      if (ownerEmail == currentUserEmail) {
        return CollaborationFailure(
          'You are the owner. Transfer ownership before leaving.',
        );
      }

      final driveFileId = isFolder
          ? (item as IsarFolder).driveFileId
          : (item as IsarNoteDocument).driveFileId;

      // Revoke own permission on Drive
      if (driveFileId != null) {
        await _revokePermission(driveFileId, currentUserEmail);
      }

      // Convert the item locally to a personal copy
      if (isFolder) {
        final folder = item as IsarFolder;
        folder.driveFileId = null;
        folder.ownerEmail = currentUserEmail;
        folder.collaborators = [];
        folder.adminEmails = [];
        folder.isShared = false;
        await noteRepository.saveFolder(folder);
      } else {
        final note = item as IsarNoteDocument;
        note.driveFileId = null;
        note.ownerEmail = currentUserEmail;
        note.collaborators = [];
        note.adminEmails = [];
        note.isShared = false;
        note.updatedAt = DateTime.now();
        await noteRepository.saveNote(note);
      }

      print('[CloudSync] $currentUserEmail left collaboration on $itemId');
      return CollaborationSuccess();
    } catch (e) {
      print('[CloudSync] leaveCollaboration failed: $e');
      return CollaborationFailure(e.toString());
    } finally {
      _isOperationInProgress = false;
    }
  }

  /// Returns the list of [CollaboratorProfile]s for a shared item
  /// by querying the Drive permissions API.
  Future<List<CollaboratorProfile>> getCollaboratorProfiles(
    String driveFileId,
    String ownerEmail,
    List<String> adminEmails,
  ) async {
    try {
      final driveApi = await _getDriveApi();
      final result = await driveApi.permissions.list(
        driveFileId,
        $fields: 'permissions(id, emailAddress, displayName, photoLink, role)',
      );
      if (result.permissions == null) return [];

      return result.permissions!
          .where((p) => p.emailAddress != null)
          .map((p) {
            CollaboratorRole role;
            if (p.emailAddress == ownerEmail || p.role == 'owner') {
              role = CollaboratorRole.owner;
            } else if (adminEmails.contains(p.emailAddress)) {
              role = CollaboratorRole.admin;
            } else {
              role = CollaboratorRole.collaborator;
            }
            return CollaboratorProfile(
              email: p.emailAddress!,
              displayName: p.displayName ?? p.emailAddress!,
              photoUrl: p.photoLink,
              role: role,
              permissionId: p.id,
            );
          })
          .toList();
    } catch (e) {
      print('[CloudSync] getCollaboratorProfiles failed: $e');
      return [];
    }
  }

  /// Fetches notes/folders shared WITH the current user from Google Drive.
  /// Also creates shortcuts in the user's VisNotes/Shared/ folder.
  Future<void> fetchSharedItems() async {
    if (_isOperationInProgress) return;
    _isOperationInProgress = true;
    try {
      final driveApi = await _getDriveApi();
      final mySharedFolderId = await _getOrCreateSharedFolder();

      final list = await driveApi.files.list(
        q: "sharedWithMe = true and (mimeType = 'application/json' or mimeType = 'application/vnd.google-apps.folder') and trashed = false",
        $fields: 'files(id, name, mimeType, description, owners, modifiedTime)',
      );

      if (list.files == null || list.files!.isEmpty) {
        print('[CloudSync] No shared items found.');
        _isOperationInProgress = false;
        return;
      }

      final sharedFolders = list.files!.where((f) => f.mimeType == 'application/vnd.google-apps.folder').toList();
      final sharedNotes = list.files!.where((f) => f.mimeType == 'application/json').toList();

      // 1. Process Folders first so local parents exist for children
      for (final file in sharedFolders) {
        // Only process folders that have a JSON description (our metadata payload)
        if (file.description == null || !file.description!.trim().startsWith('{')) continue;

        print('[CloudSync] Processing shared folder: ${file.name} (${file.id})');
        if (mySharedFolderId != null) {
          try {
            await driveApi.files.create(
              drive.File()
                ..name = file.name
                ..mimeType = 'application/vnd.google-apps.shortcut'
                ..parents = [mySharedFolderId]
                ..shortcutDetails = (drive.FileShortcutDetails()..targetId = file.id),
            );
          } catch (_) {}
        }
        await _importSharedFolder(file.id!, file.description, file.owners?.first.emailAddress);
        
        // Fetch notes inside this shared folder (they don't show up in sharedWithMe = true)
        await _fetchChildrenOfSharedFolder(file.id!);
      }

      // 2. Process Notes
      for (final file in sharedNotes) {
        if (file.name == null || !file.name!.startsWith('note_')) continue;
        print('[CloudSync] Processing shared file: ${file.name} (${file.id})');

        // Create shortcut in recipient's VisNotes/Shared/
        if (mySharedFolderId != null) {
          try {
            await driveApi.files.create(
              drive.File()
                ..name = file.name
                ..mimeType = 'application/vnd.google-apps.shortcut'
                ..parents = [mySharedFolderId]
                ..shortcutDetails = (drive.FileShortcutDetails()..targetId = file.id),
            );
          } catch (_) {
            // Shortcut already exists — not an error
          }
        }
        await _importSharedNote(file.id!, file.name!, file.owners?.first.emailAddress, file.modifiedTime);
        print('[CloudSync] Imported shared note: ${file.name}');
      }
      _isOperationInProgress = false;
    } catch (e) {
      _isOperationInProgress = false;
      print('[CloudSync] Fetch shared items failed: $e');
    }
  }

  /// On login: checks each locally-stored shared note/folder against Drive.
  /// If the file returns 403/404, the user no longer has access — convert to local copy.
  Future<void> cleanupRevokedSharedItems(String currentUserEmail) async {
    try {
      final driveApi = await _getDriveApi();

      final sharedNotes = await noteRepository.getSharedNotes();
      for (final note in sharedNotes) {
        if (note.driveFileId == null) continue;
        try {
          await driveApi.files.get(note.driveFileId!, $fields: 'id');
        } catch (_) {
          print('[CloudSync] Access revoked for note ${note.id}, converting to local copy.');
          note.driveFileId = null;
          note.ownerEmail = currentUserEmail;
          note.collaborators = [];
          note.adminEmails = [];
          note.isShared = false;
          note.updatedAt = DateTime.now();
          await noteRepository.saveNote(note);
        }
      }

      final sharedFolders = await noteRepository.getSharedFolders();
      for (final folder in sharedFolders) {
        if (folder.driveFileId == null) continue;
        try {
          await driveApi.files.get(folder.driveFileId!, $fields: 'id');
        } catch (_) {
          print('[CloudSync] Access revoked for folder ${folder.id}, converting to local copy.');
          folder.driveFileId = null;
          folder.ownerEmail = currentUserEmail;
          folder.collaborators = [];
          folder.adminEmails = [];
          folder.isShared = false;
          await noteRepository.saveFolder(folder);
        }
      }
    } catch (e) {
      print('[CloudSync] cleanupRevokedSharedItems failed: $e');
    }
  }

  // ─── Private Collaboration Helpers ───────────────────────────────────────

  Future<CollaborationResult> _addCollaboratorToNote(
    String noteId,
    String email,
    String currentUserEmail,
  ) async {
    final note = await noteRepository.getNoteById(noteId);
    if (note == null) return CollaborationFailure('Note not found.');

    // Ensure the item is on Drive in the Shared folder
    final sharedFolderId = await _getOrCreateSharedFolder();
    if (sharedFolderId == null) return CollaborationFailure('Could not access Drive Shared folder.');

    final driveFileId = await _uploadIndividualNote(note, sharedFolderId);
    if (driveFileId == null) return CollaborationFailure('Could not upload note to Drive.');

    // Grant write permission
    final success = await _grantWritePermission(driveFileId, email);
    if (!success) return CollaborationFailure('Could not grant Drive permission.');

    // Update local collaborators list
    final collaborators = List<String>.from(note.collaborators);
    if (!collaborators.contains(email)) collaborators.add(email);

    await noteRepository.updateNoteCollaborators(
      noteId, collaborators, List<String>.from(note.adminEmails));

    // Update driveFileId if it changed
    if (note.driveFileId != driveFileId) {
      await noteRepository.updateItemSharedStatus(
          noteId, false, isShared: true, driveFileId: driveFileId);
    }

    // Write updated metadata to Drive
    await _syncCollaborationMetadata(noteId, false);
    print('[CloudSync] Added collaborator $email to note $noteId');
    return CollaborationSuccess();
  }

  Future<CollaborationResult> _addCollaboratorToFolder(
    String folderId,
    String email,
    String currentUserEmail,
  ) async {
    final folder = await noteRepository.getFolderById(folderId);
    if (folder == null) return CollaborationFailure('Folder not found.');

    final sharedFolderId = await _getOrCreateSharedFolder();
    if (sharedFolderId == null) return CollaborationFailure('Could not access Drive Shared folder.');

    // Upload folder to Drive
    final driveFolderId = await _uploadIndividualFolder(folder, sharedFolderId);
    if (driveFolderId == null) return CollaborationFailure('Could not upload folder to Drive.');

    // Grant write permission on folder
    await _grantWritePermission(driveFolderId, email);

    // Upload and grant access to all child notes
    await _recursivelyShareChildren(folderId, driveFolderId, email);

    // Update local collaborators list
    final collaborators = List<String>.from(folder.collaborators);
    if (!collaborators.contains(email)) collaborators.add(email);
    await noteRepository.updateFolderCollaborators(
        folderId, collaborators, List<String>.from(folder.adminEmails));

    if (folder.driveFileId != driveFolderId) {
      await noteRepository.updateItemSharedStatus(
          folderId, true, isShared: true, driveFileId: driveFolderId);
    }

    await _syncCollaborationMetadata(folderId, true);
    print('[CloudSync] Added collaborator $email to folder $folderId');
    return CollaborationSuccess();
  }

  /// Rewrites the note/folder JSON on Drive to reflect the latest
  /// collaborators and adminEmails lists.
  Future<void> _syncCollaborationMetadata(String itemId, bool isFolder) async {
    try {
      final driveApi = await _getDriveApi();
      if (isFolder) {
        final folder = await noteRepository.getFolderById(itemId);
        if (folder == null || folder.driveFileId == null) return;
        
        final dto = IsarFolderMapper.toDto(folder);
        final description = jsonEncode(dto.toJson());
        
        await driveApi.files.update(
          drive.File()..description = description,
          folder.driveFileId!,
        );
        return;
      }
      final note = await noteRepository.getNoteById(itemId);
      if (note == null || note.driveFileId == null) return;
      
      final dto = IsarNoteMapper.toDto(note);
      final content = jsonEncode(dto.toJson());
      final bytes = utf8.encode(content);
      await driveApi.files.update(
        drive.File()..name = 'note_${note.id}.json',
        note.driveFileId!,
        uploadMedia: drive.Media(Stream.value(bytes), bytes.length, contentType: 'application/json'),
      );
    } catch (e) {
      print('[CloudSync] _syncCollaborationMetadata failed: $e');
    }
  }

  /// Revokes a specific user's Drive permission on a file.
  Future<void> _revokePermission(String fileId, String email) async {
    try {
      final driveApi = await _getDriveApi();
      final perms = await driveApi.permissions.list(
        fileId,
        $fields: 'permissions(id, emailAddress)',
      );
      final perm = perms.permissions?.firstWhere(
        (p) => p.emailAddress == email,
        orElse: () => drive.Permission(),
      );
      if (perm?.id != null) {
        await driveApi.permissions.delete(fileId, perm!.id!);
        print('[CloudSync] Revoked permission for $email on $fileId');
      }
    } catch (e) {
      print('[CloudSync] _revokePermission failed for $email: $e');
    }
  }

  Future<String?> _uploadIndividualNote(IsarNoteDocument note, String parentId) async {
    final driveApi = await _getDriveApi();
    final dto      = IsarNoteMapper.toDto(note);
    final content  = jsonEncode(dto.toJson());
    final bytes    = utf8.encode(content);
    final fileName = 'note_${note.id}.json';

    drive.Media buildMedia() =>
        drive.Media(Stream.value(bytes), bytes.length, contentType: 'application/json');

    if (note.driveFileId != null) {
      try {
        await driveApi.files.update(
          drive.File()..name = fileName,
          note.driveFileId!,
          uploadMedia: buildMedia(),
        );
        return note.driveFileId;
      } catch (e) {
        print('[CloudSync] Stale Drive file ID, creating fresh copy: $e');
      }
    }

    final created = await driveApi.files.create(
      drive.File()
        ..name    = fileName
        ..parents = [parentId]
        ..mimeType = 'application/json',
      uploadMedia: buildMedia(),
    );
    return created.id;
  }

  Future<String?> _uploadIndividualFolder(IsarFolder folder, String parentId) async {
    final driveApi = await _getDriveApi();
    if (folder.driveFileId != null) return folder.driveFileId;
    
    final dto = IsarFolderMapper.toDto(folder);
    final description = jsonEncode(dto.toJson());

    final created = await driveApi.files.create(
      drive.File()
        ..name     = folder.name ?? 'Untitled Folder'
        ..parents  = [parentId]
        ..mimeType = 'application/vnd.google-apps.folder'
        ..description = description,
    );
    return created.id;
  }

  Future<bool> _grantWritePermission(String fileId, String email) async {
    try {
      final driveApi = await _getDriveApi();
      await driveApi.permissions.create(
        drive.Permission()
          ..role = 'writer'
          ..type = 'user'
          ..emailAddress = email,
        fileId,
        sendNotificationEmail: true,
      );
      return true;
    } catch (e) {
      print('[CloudSync] _grantWritePermission failed: $e');
      return false;
    }
  }

  Future<void> _importSharedNote(String fileId, String fileName, String? ownerEmail, DateTime? driveModifiedTime) async {
    // 1. Fast Path Optimization: Skip downloading large JSON if our local DB is already up-to-date
    try {
      if (driveModifiedTime != null && fileName.startsWith('note_')) {
        final localId = fileName.replaceAll('note_', '').replaceAll('.json', '');
        final existingNote = await noteRepository.getNoteById(localId);
        if (existingNote != null && existingNote.updatedAt != null) {
          final localUpdatedUtc = existingNote.updatedAt!.toUtc();
          // If Drive's modification time is roughly equal to (or older than) our local copy, skip download!
          // We add a 1-minute buffer to absorb the small latency gap between local save and Drive upload completion.
          if (driveModifiedTime.isBefore(localUpdatedUtc.add(const Duration(minutes: 1)))) {
            return; 
          }
        }
      }
    } catch (_) {} // On any parsing error, safely fallback to full download.

    // 2. Slow Path: Download from Drive
    final driveApi = await _getDriveApi();
    final media = await driveApi.files.get(
        fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    final chunks  = await media.stream.toList();
    final content = utf8.decode(chunks.expand((c) => c).toList());
    final dto  = NoteDto.fromJson(jsonDecode(content) as Map<String, dynamic>);
    final note = IsarNoteMapper.fromDto(dto);
    note.isShared    = true;
    note.driveFileId = fileId;
    note.ownerEmail  = ownerEmail;
    
    // Check if the parent folder exists locally. If not, orphan it to the root
    // so it's not hidden forever.
    if (note.parentFolderId != null) {
      final parentFolder = await noteRepository.getFolderById(note.parentFolderId!);
      if (parentFolder == null) {
        note.parentFolderId = null;
      }
    }

    await noteRepository.saveNote(note);
  }

  Future<void> _importSharedFolder(String fileId, String? description, String? ownerEmail) async {
    if (description == null || description.isEmpty) return;
    try {
      final dto = FolderDto.fromJson(jsonDecode(description) as Map<String, dynamic>);
      final folder = IsarFolderMapper.fromDto(dto);
      folder.isShared = true;
      folder.driveFileId = fileId;
      folder.ownerEmail = ownerEmail;
      
      // If parent folder was not shared or doesn't exist, move to root.
      if (folder.parentFolderId != null) {
        final parentFolder = await noteRepository.getFolderById(folder.parentFolderId!);
        if (parentFolder == null) {
          folder.parentFolderId = null;
        }
      }

      await noteRepository.saveFolder(folder);
    } catch (e) {
      print('[CloudSync] _importSharedFolder failed to parse description: $e');
    }
  }

  Future<void> _fetchChildrenOfSharedFolder(String driveFolderId) async {
    try {
      final driveApi = await _getDriveApi();
      final list = await driveApi.files.list(
        q: "'$driveFolderId' in parents and (mimeType = 'application/json' or mimeType = 'application/vnd.google-apps.folder') and trashed = false",
        $fields: 'files(id, name, mimeType, description, owners, modifiedTime)',
      );
      if (list.files == null) return;
      
      final sharedFolders = list.files!.where((f) => f.mimeType == 'application/vnd.google-apps.folder').toList();
      final sharedNotes = list.files!.where((f) => f.mimeType == 'application/json').toList();

      for (final file in sharedFolders) {
        if (file.description == null || !file.description!.trim().startsWith('{')) continue;
        print('[CloudSync] Processing child folder: ${file.name} (${file.id})');
        await _importSharedFolder(file.id!, file.description, file.owners?.first?.emailAddress);
        // Recurse into this child folder
        await _fetchChildrenOfSharedFolder(file.id!);
      }

      for (final file in sharedNotes) {
        if (file.name == null || !file.name!.startsWith('note_')) continue;
        print('[CloudSync] Processing child note: ${file.name} (${file.id})');
        await _importSharedNote(file.id!, file.name!, file.owners?.first?.emailAddress, file.modifiedTime);
      }
    } catch (e) {
      print('[CloudSync] _fetchChildrenOfSharedFolder failed: $e');
    }
  }

  Future<void> _recursivelyShareChildren(String localFolderId, String driveFolderId, String email) async {
    // 1. Share Child Notes
    final childNotes = await noteRepository.getNotesByParent(localFolderId);
    for (final note in childNotes) {
      final noteFileId = await _uploadIndividualNote(note, driveFolderId);
      if (noteFileId != null) {
        await _grantWritePermission(noteFileId, email);
        await noteRepository.updateItemSharedStatus(
            note.id!, false, isShared: true, driveFileId: noteFileId);
      }
    }

    // 2. Share Child Folders
    final childFolders = await noteRepository.getFoldersByParent(localFolderId);
    for (final childFolder in childFolders) {
      final childDriveFolderId = await _uploadIndividualFolder(childFolder, driveFolderId);
      if (childDriveFolderId != null) {
        await _grantWritePermission(childDriveFolderId, email);
        
        final collaborators = List<String>.from(childFolder.collaborators);
        if (!collaborators.contains(email)) collaborators.add(email);
        await noteRepository.updateFolderCollaborators(
            childFolder.id!, collaborators, List<String>.from(childFolder.adminEmails));

        await noteRepository.updateItemSharedStatus(
            childFolder.id!, true, isShared: true, driveFileId: childDriveFolderId);
        
        await _syncCollaborationMetadata(childFolder.id!, true);

        // Recurse
        await _recursivelyShareChildren(childFolder.id!, childDriveFolderId, email);
      }
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

// ─── Collaboration Result ─────────────────────────────────────────────────

sealed class CollaborationResult {}

class CollaborationSuccess extends CollaborationResult {
  CollaborationSuccess();
}

class CollaborationFailure extends CollaborationResult {
  final String reason;
  CollaborationFailure(this.reason);
}
