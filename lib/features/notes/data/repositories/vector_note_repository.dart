import 'dart:async';
import 'package:isar/isar.dart';
import '../../domain/entities/vector_canvas/vector_note_document.dart';
import '../models/isar_vector_note_model.dart';
import '../serialization/mappers/vector_note_mapper.dart';
import 'note_repository.dart';

class VectorNoteRepository {
  final NoteRepository _noteRepository;
  final _changeController = StreamController<void>.broadcast();
  Stream<void> get onDataChanged => _changeController.stream;

  VectorNoteRepository({required NoteRepository noteRepository})
      : _noteRepository = noteRepository;

  Future<Isar> get _db => _noteRepository.db;

  /// Loads a vector note from database by its String ID
  Future<VectorNoteDocument?> getVectorNoteById(String id) async {
    final isar = await _db;
    final isarDoc = await isar.isarVectorNoteDocuments.filter().idEqualTo(id).findFirst();
    if (isarDoc == null) return null;
    return VectorNoteMapper.toDomain(isarDoc);
  }

  /// Fetches all active (non-deleted) vector notes located in a specific folder
  Future<List<VectorNoteDocument>> getVectorNotesByParent(String? parentId) async {
    final isar = await _db;
    final List<IsarVectorNoteDocument> results;
    if (parentId == null) {
      results = await isar.isarVectorNoteDocuments.filter()
          .parentFolderIdIsNull()
          .isDeletedEqualTo(false)
          .findAll();
    } else {
      results = await isar.isarVectorNoteDocuments.filter()
          .parentFolderIdEqualTo(parentId)
          .isDeletedEqualTo(false)
          .findAll();
    }
    return results.map(VectorNoteMapper.toDomain).toList();
  }

  /// Persists a vector note into Isar database (inserts or updates existing)
  Future<void> saveVectorNote(VectorNoteDocument doc) async {
    final isar = await _db;
    final isarDoc = VectorNoteMapper.toIsar(doc);
    
    // Maintain existing auto-increment id if it's already in the database
    final existing = await isar.isarVectorNoteDocuments.filter().idEqualTo(doc.id).findFirst();
    if (existing != null) {
      isarDoc.isarId = existing.isarId;
    }

    await isar.writeTxn(() async {
      await isar.isarVectorNoteDocuments.put(isarDoc);
    });
    _changeController.add(null);
  }

  /// Trashes a vector note (marks as deleted)
  Future<void> trashVectorNote(String id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      final note = await isar.isarVectorNoteDocuments.filter().idEqualTo(id).findFirst();
      if (note != null) {
        note.isDeleted = true;
        note.deletedAt = DateTime.now();
        await isar.isarVectorNoteDocuments.put(note);
      }
    });
    _changeController.add(null);
  }

  /// Permanently purges a vector note
  Future<void> deleteVectorNotePermanently(String id) async {
    final isar = await _db;
    await isar.writeTxn(() async {
      await isar.isarVectorNoteDocuments.filter().idEqualTo(id).deleteAll();
    });
    _changeController.add(null);
  }
}
