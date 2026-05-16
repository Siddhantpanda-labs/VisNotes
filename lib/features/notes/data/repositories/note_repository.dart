import 'dart:async';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/isar_note_model.dart';

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
        [IsarNoteDocumentSchema, IsarFolderSchema, IsarTagSchema, IsarUserSettingsSchema],
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
}
