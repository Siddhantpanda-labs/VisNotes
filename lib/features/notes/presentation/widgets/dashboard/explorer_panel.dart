import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/isar_note_model.dart';
import '../../../data/mappers/note_mapper.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../pages/note_editor_page.dart';
import '../../pages/vector_editor_page.dart';

class ExplorerPanel extends StatelessWidget {
  final VoidCallback onClose;
  const ExplorerPanel({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(10, 0),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'EXPLORER',
                  style: GoogleFonts.outfit(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, size: 20),
                  onPressed: onClose,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoaded) {
                  // Build root level
                  final rootFolders = state.allFolders.where((f) => f.parentFolderId == null).toList();
                  final rootNotes = state.notes.where((n) => n.parentFolderId == null).toList();

                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      ...rootFolders.map((f) => RecursiveFolderTile(
                        folder: f, 
                        allFolders: state.allFolders,
                        depth: 0,
                      )),
                      ...rootNotes.map((n) => ExplorerNoteTile(note: n)),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}

class RecursiveFolderTile extends StatefulWidget {
  final IsarFolder folder;
  final List<IsarFolder> allFolders;
  final int depth;

  const RecursiveFolderTile({
    super.key, 
    required this.folder, 
    required this.allFolders,
    required this.depth,
  });

  @override
  State<RecursiveFolderTile> createState() => _RecursiveFolderTileState();
}

class _RecursiveFolderTileState extends State<RecursiveFolderTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final children = widget.allFolders.where((f) => f.parentFolderId == widget.folder.id).toList();
    
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + (widget.depth * 20.0), right: 16.0),
          leading: Icon(
            _isExpanded ? Icons.folder_open_outlined : Icons.folder_outlined, 
            size: 20, 
            color: Colors.amber,
          ),
          trailing: children.isNotEmpty 
            ? Icon(_isExpanded ? Icons.expand_more : Icons.chevron_right, size: 16)
            : null,
          title: Text(
            widget.folder.name ?? 'Untitled Folder',
            style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
          ),
          onTap: () {
            setState(() => _isExpanded = !_isExpanded);
            context.read<DashboardBloc>().add(OpenFolder(widget.folder.id));
          },
        ),
        if (_isExpanded)
          ...children.map((child) => RecursiveFolderTile(
            folder: child, 
            allFolders: widget.allFolders,
            depth: widget.depth + 1,
          )),
      ],
    );
  }
}

class ExplorerNoteTile extends StatelessWidget {
  final IsarNoteDocument note;
  final int depth;
  const ExplorerNoteTile({super.key, required this.note, this.depth = 0});

  @override
  Widget build(BuildContext context) {
    final isVector = note.noteType == 'vector';
    return ListTile(
      contentPadding: EdgeInsets.only(left: 16.0 + (depth * 20.0), right: 16.0),
      leading: Icon(
        isVector ? Icons.gesture_rounded : Icons.note_alt_outlined, 
        size: 20, 
        color: isVector ? const Color(0xFF6366F1) : Colors.blueAccent,
      ),
      title: Text(
        note.title ?? 'Untitled Note',
        style: GoogleFonts.outfit(fontSize: 14),
      ),
      onTap: () {
        if (isVector) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => VectorEditorPage(
                noteId: note.id ?? '',
                noteTitle: note.title ?? 'Vector Note',
              ),
            ),
          ).then((_) {
            if (context.mounted) {
              context.read<DashboardBloc>().add(const LoadDashboard());
            }
          });
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteEditorPage(
              initialDocument: NoteMapper.toDomain(note),
            ),
          ),
        ).then((_) {
          if (context.mounted) {
            context.read<DashboardBloc>().add(const LoadDashboard());
          }
        });
      },
    );
  }
}
