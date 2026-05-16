import 'dart:async';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/isar_note_model.dart';
import '../models/app_settings_model.dart';

class NoteRepository {
  late Future<Isar> db;
  final _changeController = StreamController<void>.broadcast();
  Stream<void> get onDataChanged => _changeController.stream;

  NoteRepository() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [
          IsarNoteDocumentSchema, 
          IsarFolderSchema, 
          IsarTagSchema, 
          IsarUserSettingsSchema,
          IsarAppSettingsSchema,
        ],
        directory: dir.path,
        inspector: true,
      );
    }
    return Isar.getInstance()!;
  }

  // Notes
  Future<IsarNoteDocument?> getNoteById(String id) async {
    final isar = await db;
    return await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
  }

  Future<List<IsarNoteDocument>> getAllNotes() async {
    final isar = await db;
    return await isar.isarNoteDocuments.where().findAll();
  }

  Future<List<IsarNoteDocument>> getNotesByParent(String? parentId) async {
    final isar = await db;
    if (parentId == null) {
      return await isar.isarNoteDocuments.filter()
          .parentFolderIdIsNull()
          .isDeletedEqualTo(false)
          .findAll();
    }
    return await isar.isarNoteDocuments.filter()
        .parentFolderIdEqualTo(parentId)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<void> saveNote(IsarNoteDocument note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarNoteDocuments.put(note);
    });
    _changeController.add(null);
  }

  Future<void> trashNote(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final note = await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
      if (note != null) {
        note.isDeleted = true;
        note.deletedAt = DateTime.now();
        await isar.isarNoteDocuments.put(note);
      }
    });
    _changeController.add(null);
  }

  Future<void> restoreNote(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final note = await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
      if (note != null) {
        note.isDeleted = false;
        note.deletedAt = null;
        await isar.isarNoteDocuments.put(note);
      }
    });
  }

  Future<void> deleteNotePermanently(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarNoteDocuments.filter().idEqualTo(id).deleteAll();
    });
  }

  Future<void> renameNote(String id, String newTitle) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final note = await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
      if (note != null) {
        note.title = newTitle;
        await isar.isarNoteDocuments.put(note);
      }
    });
  }

  Future<void> moveNote(String noteId, String? targetFolderId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final note = await isar.isarNoteDocuments.filter().idEqualTo(noteId).findFirst();
      if (note != null) {
        note.parentFolderId = targetFolderId;
        await isar.isarNoteDocuments.put(note);
      }
    });
    _changeController.add(null);
  }

  // Folders
  Future<IsarFolder?> getFolderById(String id) async {
    final isar = await db;
    return await isar.isarFolders.filter().idEqualTo(id).findFirst();
  }

  Future<List<IsarFolder>> getAllFolders() async {
    final isar = await db;
    return await isar.isarFolders.filter().isDeletedEqualTo(false).findAll();
  }

  Future<List<IsarFolder>> getFoldersByParent(String? parentId) async {
    final isar = await db;
    if (parentId == null) {
      return await isar.isarFolders.filter()
          .parentFolderIdIsNull()
          .isDeletedEqualTo(false)
          .findAll();
    }
    return await isar.isarFolders.filter()
        .parentFolderIdEqualTo(parentId)
        .isDeletedEqualTo(false)
        .findAll();
  }

  Future<void> saveFolder(IsarFolder folder) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarFolders.put(folder);
    });
    _changeController.add(null);
  }

  Future<void> trashFolder(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
      if (folder != null) {
        folder.isDeleted = true;
        folder.deletedAt = DateTime.now();
        await isar.isarFolders.put(folder);
        
        // Also soft delete everything inside? 
        // For simplicity, we just mark the folder. 
        // When viewing trash, we might want to see the folder and restore its contents.
      }
    });
  }

  Future<void> restoreFolder(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
      if (folder != null) {
        folder.isDeleted = false;
        folder.deletedAt = null;
        await isar.isarFolders.put(folder);
      }
    });
  }

  Future<void> deleteFolderPermanently(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarFolders.filter().idEqualTo(id).deleteAll();
    });
  }

  // Trash specific fetches
  Future<List<IsarNoteDocument>> getTrashNotes() async {
    final isar = await db;
    return await isar.isarNoteDocuments.filter().isDeletedEqualTo(true).findAll();
  }

  Future<List<IsarFolder>> getTrashFolders() async {
    final isar = await db;
    return await isar.isarFolders.filter().isDeletedEqualTo(true).findAll();
  }

  Future<void> renameFolder(String id, String newName) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
      if (folder != null) {
        folder.name = newName;
        await isar.isarFolders.put(folder);
      }
    });
  }

  Future<void> moveFolder(String folderId, String? targetFolderId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(folderId).findFirst();
      if (folder != null) {
        folder.parentFolderId = targetFolderId;
        await isar.isarFolders.put(folder);
      }
    });
  }

  Future<void> togglePin(String id, bool isFolder) async {
    final isar = await db;
    await isar.writeTxn(() async {
      if (isFolder) {
        final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
        if (folder != null) {
          folder.isPinned = !folder.isPinned;
          await isar.isarFolders.put(folder);
        }
      } else {
        final note = await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
        if (note != null) {
          note.isPinned = !note.isPinned;
          await isar.isarNoteDocuments.put(note);
        }
      }
    });
  }

  Future<void> updateFolderCustomization(String id, {int? colorValue, int? iconCodePoint}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
      if (folder != null) {
        if (colorValue != null) folder.colorValue = colorValue;
        if (iconCodePoint != null) folder.iconCodePoint = iconCodePoint;
        await isar.isarFolders.put(folder);
      }
    });
  }

  // Tags
  Future<List<IsarTag>> getAllTags() async {
    final isar = await db;
    return await isar.isarTags.where().findAll();
  }

  Future<void> saveTag(IsarTag tag) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarTags.put(tag);
    });
  }

  Future<void> deleteTag(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarTags.filter().idEqualTo(id).deleteAll();
    });
  }

  // User Settings
  Future<IsarUserSettings?> getUserSettings() async {
    final isar = await db;
    return await isar.isarUserSettings.where().findFirst();
  }

  Future<void> saveUserSettings(IsarUserSettings settings) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarUserSettings.put(settings);
    });
    // Note: intentionally NOT emitting _changeController here.
    // User settings are internal metadata, not user content.
    // Emitting would trigger spurious auto-syncs and dashboard reloads.
  }

  // Settings & Security
  Future<IsarAppSettings> getSettings() async {
    final isar = await db;
    final settings = await isar.isarAppSettings.get(0);
    return settings ?? IsarAppSettings();
  }

  Future<void> updateSettings(IsarAppSettings settings) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarAppSettings.put(settings);
    });
    _changeController.add(null);
  }

  Future<void> deleteAllLockedNotes() async {
    final isar = await db;
    await isar.writeTxn(() async {
      final lockedNotes = await isar.isarNoteDocuments.filter()
          .isLockedEqualTo(true)
          .findAll();
      
      final idsToDelete = lockedNotes.map((n) => n.isarId).toList();
      await isar.isarNoteDocuments.deleteAll(idsToDelete);
    });
    _changeController.add(null);
  }

  Future<void> updateItemSharedStatus(String id, bool isFolder, {required bool isShared, String? driveFileId}) async {
    final isar = await db;
    await isar.writeTxn(() async {
      if (isFolder) {
        final folder = await isar.isarFolders.filter().idEqualTo(id).findFirst();
        if (folder != null) {
          folder.isShared = isShared;
          if (driveFileId != null) folder.driveFileId = driveFileId;
          await isar.isarFolders.put(folder);
        }
      } else {
        final note = await isar.isarNoteDocuments.filter().idEqualTo(id).findFirst();
        if (note != null) {
          note.isShared = isShared;
          if (driveFileId != null) note.driveFileId = driveFileId;
          await isar.isarNoteDocuments.put(note);
        }
      }
    });
    _changeController.add(null);
  }

  /// Clears all account-specific data (backup-enabled notes and all folders) 
  /// while preserving local-only (backup-excluded) notes.
  Future<void> clearAccountData() async {
    final isar = await db;
    await isar.writeTxn(() async {
      // 1. Delete all backup-enabled notes
      await isar.isarNoteDocuments.filter()
          .excludeFromBackupEqualTo(false)
          .deleteAll();
      
      // 2. Delete all folders (folders are account-bound by design in VisNotes)
      await isar.isarFolders.where().deleteAll();
      
      // 3. Clear any folder associations for the remaining local-only notes
      final localNotes = await isar.isarNoteDocuments.where().findAll();
      for (final note in localNotes) {
        note.parentFolderId = null;
        await isar.isarNoteDocuments.put(note);
      }
    });
    _changeController.add(null);
  }

  // ─── Collaboration ────────────────────────────────────────────────────────

  /// Updates the collaborator + admin lists for a note and emits a change.
  Future<void> updateNoteCollaborators(
    String noteId,
    List<String> collaborators,
    List<String> adminEmails,
  ) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final note = await isar.isarNoteDocuments.filter().idEqualTo(noteId).findFirst();
      if (note != null) {
        note.collaborators = List<String>.from(collaborators);
        note.adminEmails   = List<String>.from(adminEmails);
        note.isShared = collaborators.isNotEmpty;
        await isar.isarNoteDocuments.put(note);
      }
    });
    _changeController.add(null);
  }

  /// Updates the collaborator + admin lists for a folder and emits a change.
  Future<void> updateFolderCollaborators(
    String folderId,
    List<String> collaborators,
    List<String> adminEmails,
  ) async {
    final isar = await db;
    await isar.writeTxn(() async {
      final folder = await isar.isarFolders.filter().idEqualTo(folderId).findFirst();
      if (folder != null) {
        folder.collaborators = List<String>.from(collaborators);
        folder.adminEmails   = List<String>.from(adminEmails);
        folder.isShared = collaborators.isNotEmpty;
        await isar.isarFolders.put(folder);
      }
    });
    _changeController.add(null);
  }

  /// Permanently deletes a note and emits a change event.
  Future<void> permanentlyDeleteNote(String noteId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarNoteDocuments.filter().idEqualTo(noteId).deleteAll();
    });
    _changeController.add(null);
  }

  /// Permanently deletes a folder and ALL its child notes, then emits a change.
  Future<void> permanentlyDeleteFolder(String folderId) async {
    final isar = await db;
    await isar.writeTxn(() async {
      // Delete all notes that belong to this folder
      await isar.isarNoteDocuments
          .filter()
          .parentFolderIdEqualTo(folderId)
          .deleteAll();
      // Delete the folder itself
      await isar.isarFolders.filter().idEqualTo(folderId).deleteAll();
    });
    _changeController.add(null);
  }

  /// Returns all notes that are marked as shared (received from others).
  Future<List<IsarNoteDocument>> getSharedNotes() async {
    final isar = await db;
    return await isar.isarNoteDocuments
        .filter()
        .isSharedEqualTo(true)
        .isDeletedEqualTo(false)
        .findAll();
  }

  /// Returns all folders that are marked as shared (received from others).
  Future<List<IsarFolder>> getSharedFolders() async {
    final isar = await db;
    return await isar.isarFolders
        .filter()
        .isSharedEqualTo(true)
        .isDeletedEqualTo(false)
        .findAll();
  }
}
