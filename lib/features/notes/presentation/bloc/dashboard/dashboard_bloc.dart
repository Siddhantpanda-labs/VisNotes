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
  const LoadDashboard({this.folderId, this.useCurrentFolder = false});

  @override
  List<Object?> get props => [folderId, useCurrentFolder];
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
  const ToggleSelection({required this.id, required this.isFolder});
}

class ClearSelection extends DashboardEvent {}

class BulkDelete extends DashboardEvent {}

class BulkMove extends DashboardEvent {
  final String? targetFolderId;
  const BulkMove({required this.targetFolderId});
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
    );
  }

  @override
  List<Object?> get props => [
    notes, folders, allFolders, currentFolderId, currentFolder, 
    selectedNoteIds, selectedFolderIds, isSelectionMode, isTrashView
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
    on<ClearSelection>(_onClearSelection);
    on<BulkDelete>(_onBulkDelete);
    on<BulkMove>(_onBulkMove);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    final folderId = event.useCurrentFolder 
        ? (state is DashboardLoaded ? (state as DashboardLoaded).currentFolderId : null)
        : event.folderId;
    
    emit(DashboardLoading());
    try {
      final notes = await repository.getNotesByParent(folderId);
      final folders = await repository.getFoldersByParent(folderId);
      final allFolders = await repository.getAllFolders();
      
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

  void _onToggleSelection(ToggleSelection event, Emitter<DashboardState> emit) {
    if (state is! DashboardLoaded) return;
    final currentState = state as DashboardLoaded;

    final newNoteIds = Set<String>.from(currentState.selectedNoteIds);
    final newFolderIds = Set<String>.from(currentState.selectedFolderIds);

    if (event.isFolder) {
      if (newFolderIds.contains(event.id)) {
        newFolderIds.remove(event.id);
      } else {
        newFolderIds.add(event.id);
      }
    } else {
      if (newNoteIds.contains(event.id)) {
        newNoteIds.remove(event.id);
      } else {
        newNoteIds.add(event.id);
      }
    }

    final isMode = newNoteIds.isNotEmpty || newFolderIds.isNotEmpty;
    emit(currentState.copyWith(
      selectedNoteIds: newNoteIds,
      selectedFolderIds: newFolderIds,
      isSelectionMode: isMode,
    ));
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
}
