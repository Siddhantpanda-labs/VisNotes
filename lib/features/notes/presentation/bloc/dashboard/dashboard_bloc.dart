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

class LoadDashboard extends DashboardEvent {}

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

  const DashboardLoaded({required this.notes, required this.folders});

  @override
  List<Object?> get props => [notes, folders];
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
    on<UpdateNodePosition>(_onUpdateNodePosition);
    on<CreateDocument>(_onCreateDocument);
    on<CreateFolder>(_onCreateFolder);
    on<RenameNode>(_onRenameNode);
    on<DeleteNode>(_onDeleteNode);
  }

  Future<void> _onLoadDashboard(LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(DashboardLoading());
    try {
      final notes = await repository.getAllNotes();
      final folders = await repository.getAllFolders();
      emit(DashboardLoaded(notes: notes, folders: folders));
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
      add(LoadDashboard());
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onDeleteNode(DeleteNode event, Emitter<DashboardState> emit) async {
    try {
      if (event.isFolder) {
        await repository.deleteFolder(event.id);
      } else {
        await repository.deleteNote(event.id);
      }
      add(LoadDashboard());
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
      add(LoadDashboard());
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
      ..updatedAt = DateTime.now();

    await repository.saveNote(newNote);
    add(LoadDashboard());
  }

  Future<void> _onCreateFolder(CreateFolder event, Emitter<DashboardState> emit) async {
    if (state is! DashboardLoaded) return;
    
    final newFolder = IsarFolder()
      ..id = DateTime.now().millisecondsSinceEpoch.toString()
      ..name = "New Folder"
      ..dashboardX = event.x
      ..dashboardY = event.y;

    await repository.saveFolder(newFolder);
    add(LoadDashboard());
  }
}
