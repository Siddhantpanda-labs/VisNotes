import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import '../models/isar_note_model.dart';

class NoteRepository {
  late Future<Isar> db;

  NoteRepository() {
    db = openDB();
  }

  Future<Isar> openDB() async {
    if (Isar.instanceNames.isEmpty) {
      final dir = await getApplicationDocumentsDirectory();
      return await Isar.open(
        [IsarNoteDocumentSchema, IsarFolderSchema],
        directory: dir.path,
        inspector: true,
      );
    }
    return Isar.getInstance()!;
  }

  // Notes
  Future<List<IsarNoteDocument>> getAllNotes() async {
    final isar = await db;
    return await isar.isarNoteDocuments.where().findAll();
  }

  Future<void> saveNote(IsarNoteDocument note) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarNoteDocuments.put(note);
    });
  }

  Future<void> deleteNote(String id) async {
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

  // Folders
  Future<List<IsarFolder>> getAllFolders() async {
    final isar = await db;
    return await isar.isarFolders.where().findAll();
  }

  Future<void> saveFolder(IsarFolder folder) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarFolders.put(folder);
    });
  }

  Future<void> deleteFolder(String id) async {
    final isar = await db;
    await isar.writeTxn(() async {
      await isar.isarFolders.filter().idEqualTo(id).deleteAll();
    });
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
}
