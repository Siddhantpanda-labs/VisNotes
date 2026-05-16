import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/isar_note_model.dart';
import '../../../data/repositories/note_repository.dart';

// Events
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  final String? folderId;
  final bool useCurrentFolder;
  final bool isSilent;
  const LoadDashboard({this.folderId, this.useCurrentFolder = false, this.isSilent = false});

  @override
  List<Object?> get props => [folderId, useCurrentFolder, isSilent];
}

class OpenFolder extends DashboardEvent {
  final String? folderId;
  const OpenFolder(this.folderId);

  @override
  List<Object?> get props => [folderId];
}

class MoveItemToFolder extends DashboardEvent {
  final String id;
  final String? targetFolderId;
  final bool isFolder;

  const MoveItemToFolder({
    required this.id,
    required this.targetFolderId,
    required this.isFolder,
  });

  @override
  List<Object?> get props => [id, targetFolderId, isFolder];
}

class UpdateNodePosition extends DashboardEvent {
  final String id;
  final double x;
  final double y;
  final bool isFolder;

  const UpdateNodePosition({
    required this.id,
    required this.x,
    required this.y,
    this.isFolder = false,
  });

  @override
  List<Object?> get props => [id, x, y, isFolder];
}

class CreateDocument extends DashboardEvent {
  final double x;
  final double y;
  final String type; // 'vector' or 'text'
  const CreateDocument({required this.x, required this.y, required this.type});
}

class CreateFolder extends DashboardEvent {
  final double x;
  final double y;
  const CreateFolder({required this.x, required this.y});
}

class RenameNode extends DashboardEvent {
  final String id;
  final String newName;
  final bool isFolder;
  const RenameNode({required this.id, required this.newName, this.isFolder = false});
}

class DeleteNode extends DashboardEvent {
  final String id;
  final bool isFolder;
  const DeleteNode({required this.id, this.isFolder = false});
}

class LoadTrash extends DashboardEvent {}

class RestoreItem extends DashboardEvent {
  final String id;
  final bool isFolder;
  const RestoreItem({required this.id, required this.isFolder});
}

class PermanentlyDeleteItem extends DashboardEvent {
  final String id;
  final bool isFolder;
  const PermanentlyDeleteItem({required this.id, required this.isFolder});
}

class EmptyTrash extends DashboardEvent {}

class ToggleSelection extends DashboardEvent {
  final String id;
  final bool isFolder;
  const ToggleSelection({required this.id, this.isFolder = false});
}

class SetSelectionMode extends DashboardEvent {
  final bool enabled;
  const SetSelectionMode(this.enabled);
}

class ToggleBackupExclusion extends DashboardEvent {
  final String id;
  const ToggleBackupExclusion({required this.id});
}

class ClearSelection extends DashboardEvent {}

class BulkDelete extends DashboardEvent {}

class BulkMove extends DashboardEvent {
  final String? targetFolderId;
  const BulkMove({required this.targetFolderId});
}

class ToggleViewMode extends DashboardEvent {}

class UpdateFolderCustomization extends DashboardEvent {
  final String id;
  final int? colorValue;
  final int? iconCodePoint;
  const UpdateFolderCustomization({required this.id, this.colorValue, this.iconCodePoint});
}

class TogglePinNode extends DashboardEvent {
  final String id;
  final bool isFolder;
  const TogglePinNode({required this.id, required this.isFolder});
}

class LoadTags extends DashboardEvent {}

class CreateTag extends DashboardEvent {
  final String name;
  final int colorValue;
  const CreateTag({required this.name, required this.colorValue});
}

class DeleteTag extends DashboardEvent {
  final String id;
  const DeleteTag({required this.id});
}

class FilterByTag extends DashboardEvent {
  final String? tagName;
  const FilterByTag(this.tagName);
}

class ToggleTagOnNode extends DashboardEvent {
  final String nodeId;
  final String tagName;
  final bool isFolder;
  const ToggleTagOnNode({required this.nodeId, required this.tagName, required this.isFolder});
}

// States
abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final List<IsarNoteDocument> notes;
  final List<IsarFolder> folders;
  final List<IsarFolder> allFolders;
  final String? currentFolderId;
  final IsarFolder? currentFolder;
  final Set<String> selectedNoteIds;
  final Set<String> selectedFolderIds;
  final bool isSelectionMode;
  final bool isTrashView;
  final bool isListView;
  final List<IsarTag> tags;
  final String? activeTagFilter;

  const DashboardLoaded({
    required this.notes, 
    required this.folders,
    required this.allFolders,
    this.currentFolderId,
    this.currentFolder,
    this.selectedNoteIds = const {},
    this.selectedFolderIds = const {},
    this.isSelectionMode = false,
    this.isTrashView = false,
    this.isListView = false,
    this.tags = const [],
    this.activeTagFilter,
  });

  DashboardLoaded copyWith({
    List<IsarNoteDocument>? notes,
    List<IsarFolder>? folders,
    List<IsarFolder>? allFolders,
    String? currentFolderId,
    IsarFolder? currentFolder,
    Set<String>? selectedNoteIds,
    Set<String>? selectedFolderIds,
    bool? isSelectionMode,
    bool? isTrashView,
    bool? isListView,
    List<IsarTag>? tags,
    String? activeTagFilter,
  }) {
    return DashboardLoaded(
      notes: notes ?? this.notes,
      folders: folders ?? this.folders,
      allFolders: allFolders ?? this.allFolders,
      currentFolderId: currentFolderId ?? this.currentFolderId,
      currentFolder: currentFolder ?? this.currentFolder,
      selectedNoteIds: selectedNoteIds ?? this.selectedNoteIds,
      selectedFolderIds: selectedFolderIds ?? this.selectedFolderIds,
      isSelectionMode: isSelectionMode ?? this.isSelectionMode,
      isTrashView: isTrashView ?? this.isTrashView,
      isListView: isListView ?? this.isListView,
      tags: tags ?? this.tags,
      activeTagFilter: activeTagFilter ?? this.activeTagFilter,
    );
  }

  @override
  List<Object?> get props => [
    notes, folders, allFolders, currentFolderId, currentFolder, 
    selectedNoteIds, selectedFolderIds, isSelectionMode, isTrashView,
    isListView, tags, activeTagFilter,
  ];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
}

// Bloc
class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final NoteRepository repository;

  DashboardBloc({required this.repository}) : super(DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<OpenFolder>(_onOpenFolder);
    on<MoveItemToFolder>(_onMoveItemToFolder);
    on<UpdateNodePosition>(_onUpdateNodePosition);
    on<CreateDocument>(_onCreateDocument);
    on<CreateFolder>(_onCreateFolder);
    on<RenameNode>(_onRenameNode);
    on<DeleteNode>(_onDeleteNode);
    on<LoadTrash>(_onLoadTrash);
    on<RestoreItem>(_onRestoreItem);
    on<PermanentlyDeleteItem>(_onPermanentlyDeleteItem);
    on<EmptyTrash>(_onEmptyTrash);
    on<ToggleSelection>(_onToggleSelection);
    on<SetSelectionMode>(_onSetSelectionMode);
    on<ToggleBackupExclusion>(_onToggleBackupExclusion);
    on<ClearSelection>(_onClearSelection);
    on<BulkDelete>(_onBulkDelete);
    on<BulkMove>(_onBulkMove);
    on<ToggleViewMode>(_onToggleViewMode);
    on<UpdateFolderCustomization>(_onUpdateFolderCustomization);
    on<TogglePinNode>(_onTogglePinNode);
    on<LoadTags>(_onLoadTags);
    on<CreateTag>(_onCreateTag);
    on<DeleteTag>(_onDeleteTag);
    on<FilterByTag>(_onFilterByTag);
    on<ToggleTagOnNode>(_onToggleTagOnNode);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    final folderId = event.useCurrentFolder 
        ? (state is DashboardLoaded ? (state as DashboardLoaded).currentFolderId : null)
        : event.folderId;
    
    if (!event.isSilent) {
      emit(DashboardLoading());
    }
    
    try {
      final notes = await repository.getNotesByParent(folderId);
      final folders = await repository.getFoldersByParent(folderId);
      final allFolders = await repository.getAllFolders();
      final tags = await repository.getAllTags();
      
      IsarFolder? currentFolder;
      if (folderId != null) {
        currentFolder = allFolders.where((f) => f.id == folderId).firstOrNull;
      }

      emit(DashboardLoaded(
        notes: notes, 
        folders: folders,
        allFolders: allFolders,
        currentFolderId: folderId,
        currentFolder: currentFolder,
        tags: tags,
        isListView: state is DashboardLoaded ? (state as DashboardLoaded).isListView : false,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onOpenFolder(OpenFolder event, Emitter<DashboardState> emit) async {
    add(LoadDashboard(folderId: event.folderId));
  }

  Future<void> _onMoveItemToFolder(MoveItemToFolder event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.moveFolder(event.id, event.targetFolderId);
      } else {
        await repository.moveNote(event.id, event.targetFolderId);
      }
      add(const LoadDashboard(useCurrentFolder: true)); // Refresh current view
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRenameNode(RenameNode event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.renameFolder(event.id, event.newName);
      } else {
        await repository.renameNote(event.id, event.newName);
      }
      add(const LoadDashboard(useCurrentFolder: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDeleteNode(DeleteNode event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.trashFolder(event.id);
      } else {
        await repository.trashNote(event.id);
      }
      add(const LoadDashboard(useCurrentFolder: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadTrash(LoadTrash event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final notes = await repository.getTrashNotes();
      final folders = await repository.getTrashFolders();
      final allFolders = await repository.getAllFolders();
      
      emit(DashboardLoaded(
        notes: notes,
        folders: folders,
        allFolders: allFolders,
        isTrashView: true,
      ));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRestoreItem(RestoreItem event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.restoreFolder(event.id);
      } else {
        await repository.restoreNote(event.id);
      }
      add(LoadTrash());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onPermanentlyDeleteItem(PermanentlyDeleteItem event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.deleteFolderPermanently(event.id);
      } else {
        await repository.deleteNotePermanently(event.id);
      }
      add(LoadTrash());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onEmptyTrash(EmptyTrash event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    final currentState = state as DashboardLoaded;
    try {
      for (final id in currentState.folders.map((f) => f.id!)) {
        await repository.deleteFolderPermanently(id);
      }
      for (final id in currentState.notes.map((n) => n.id!)) {
        await repository.deleteNotePermanently(id);
      }
      add(LoadTrash());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onUpdateNodePosition(UpdateNodePosition event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    final currentState = state as DashboardLoaded;

    try {
      if (event.isFolder) {
        final folder = currentState.folders.firstWhere((f) => f.id == event.id);
        folder.dashboardX = event.x;
        folder.dashboardY = event.y;
        await repository.saveFolder(folder);
      } else {
        final note = currentState.notes.firstWhere((n) => n.id == event.id);
        note.dashboardX = event.x;
        note.dashboardY = event.y;
        await repository.saveNote(note);
      }
      // Re-load to ensure sync
      add(const LoadDashboard(useCurrentFolder: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onCreateDocument(CreateDocument event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    
    final newNote = IsarNoteDocument()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..title = event.type == 'vector' ? "Vector Note" : "Text Note"
      ..dashboardX = event.x
      ..dashboardY = event.y
      ..createdAt = DateTime.now()
      ..updatedAt = DateTime.now()
      ..parentFolderId = (state as DashboardLoaded).currentFolderId;

    await repository.saveNote(newNote);
    add(const LoadDashboard(useCurrentFolder: true));
  }

  Future<void> _onCreateFolder(CreateFolder event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    
    final newFolder = IsarFolder()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..name = "New Folder"
      ..dashboardX = event.x
      ..dashboardY = event.y
      ..parentFolderId = (state as DashboardLoaded).currentFolderId;

    await repository.saveFolder(newFolder);
    add(const LoadDashboard(useCurrentFolder: true));
  }

  Future<void> _onToggleBackupExclusion(ToggleBackupExclusion event, Emitter<DashboardState> emit) async {
    final note = await repository.getNoteById(event.id);
    if (note != null) {
      note.excludeFromBackup = !note.excludeFromBackup;
      await repository.saveNote(note);
      add(const LoadDashboard(useCurrentFolder: true, isSilent: true));
    }
  }

  void _onSetSelectionMode(SetSelectionMode event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final s = state as DashboardLoaded;
      emit(s.copyWith(
        isSelectionMode: event.enabled,
        selectedNoteIds: event.enabled ? s.selectedNoteIds : {},
        selectedFolderIds: event.enabled ? s.selectedFolderIds : {},
      ));
    }
  }

  void _onToggleSelection(ToggleSelection event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final s = state as DashboardLoaded;
      final newNotes = Set<String>.from(s.selectedNoteIds);
      final newFolders = Set<String>.from(s.selectedFolderIds);

      if (event.isFolder) {
        if (newFolders.contains(event.id)) {
          newFolders.remove(event.id);
        } else {
          newFolders.add(event.id);
        }
      } else {
        if (newNotes.contains(event.id)) {
          newNotes.remove(event.id);
        } else {
          newNotes.add(event.id);
        }
      }

      emit(s.copyWith(
        selectedNoteIds: newNotes,
        selectedFolderIds: newFolders,
        // If something is selected, ensure selection mode is on
        isSelectionMode: newNotes.isNotEmpty || newFolders.isNotEmpty,
      ));
    }
  }

  void _onClearSelection(ClearSelection event, Emitter<DashboardState> emit) {
    if (state is! DashboardLoaded) return;
    emit((state as DashboardLoaded).copyWith(
      selectedNoteIds: {},
      selectedFolderIds: {},
      isSelectionMode: false,
    ));
  }

  Future<void> _onBulkDelete(BulkDelete event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    final currentState = state as DashboardLoaded;

    try {
      if (currentState.isTrashView) {
        // Permanently delete if in trash
        for (final id in currentState.selectedFolderIds) {
          await repository.deleteFolderPermanently(id);
        }
        for (final id in currentState.selectedNoteIds) {
          await repository.deleteNotePermanently(id);
        }
      } else {
        // Just trash if in normal view
        for (final id in currentState.selectedFolderIds) {
          await repository.trashFolder(id);
        }
        for (final id in currentState.selectedNoteIds) {
          await repository.trashNote(id);
        }
      }
      add(const LoadDashboard(useCurrentFolder: true));
      add(ClearSelection());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onBulkMove(BulkMove event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    final currentState = state as DashboardLoaded;

    try {
      for (final id in currentState.selectedFolderIds) {
        await repository.moveFolder(id, event.targetFolderId);
      }
      for (final id in currentState.selectedNoteIds) {
        await repository.moveNote(id, event.targetFolderId);
      }
      add(const LoadDashboard(useCurrentFolder: true));
      add(ClearSelection());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onToggleViewMode(ToggleViewMode event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;
      emit(currentState.copyWith(isListView: !currentState.isListView));
    }
  }

  Future<void> _onUpdateFolderCustomization(UpdateFolderCustomization event, Emitter<DashboardState> emit) async {
    try {
      await repository.updateFolderCustomization(
        event.id, 
        colorValue: event.colorValue, 
        iconCodePoint: event.iconCodePoint
      );
      add(const LoadDashboard(useCurrentFolder: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onTogglePinNode(TogglePinNode event, Emitter<DashboardState> emit) async {
    try {
      await repository.togglePin(event.id, event.isFolder);
      add(const LoadDashboard(useCurrentFolder: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onLoadTags(LoadTags event, Emitter<DashboardState> emit) async {
    try {
      final tags = await repository.getAllTags();
      if (state is DashboardLoaded) {
        emit((state as DashboardLoaded).copyWith(tags: tags));
      }
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onCreateTag(CreateTag event, Emitter<DashboardState> emit) async {
    try {
      final tag = IsarTag()
        ..id = DateTime.now().millisecondsSinceEpoch.toString()
        ..name = event.name
        ..colorValue = event.colorValue;
      await repository.saveTag(tag);
      add(LoadTags());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDeleteTag(DeleteTag event, Emitter<DashboardState> emit) async {
    try {
      await repository.deleteTag(event.id);
      add(LoadTags());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  void _onFilterByTag(FilterByTag event, Emitter<DashboardState> emit) {
    if (state is DashboardLoaded) {
      emit((state as DashboardLoaded).copyWith(activeTagFilter: event.tagName));
    }
  }

  Future<void> _onToggleTagOnNode(ToggleTagOnNode event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        final folder = await repository.getFolderById(event.nodeId);
        if (folder != null) {
          final newTags = List<String>.from(folder.tags);
          if (newTags.contains(event.tagName)) {
            newTags.remove(event.tagName);
          } else {
            newTags.add(event.tagName);
          }
          folder.tags = newTags;
          await repository.saveFolder(folder);
        }
      } else {
        final note = await repository.getNoteById(event.nodeId);
        if (note != null) {
          final newTags = List<String>.from(note.tags);
          if (newTags.contains(event.tagName)) {
            newTags.remove(event.tagName);
          } else {
            newTags.add(event.tagName);
          }
          note.tags = newTags;
          await repository.saveNote(note);
        }
      }
      add(const LoadDashboard(useCurrentFolder: true, isSilent: true));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }
}
