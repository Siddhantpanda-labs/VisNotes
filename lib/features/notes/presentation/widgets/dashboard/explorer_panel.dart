import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/isar_note_model.dart';
import '../../../data/mappers/note_mapper.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../pages/note_editor_page.dart';

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
                  return ListView(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    children: [
                      ...state.folders.map((f) => ExplorerFolderTile(folder: f)),
                      ...state.notes.map((n) => ExplorerNoteTile(note: n)),
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

class ExplorerFolderTile extends StatelessWidget {
  final IsarFolder folder;
  const ExplorerFolderTile({super.key, required this.folder});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.folder_outlined, size: 20, color: Colors.amber),
      title: Text(
        folder.name ?? 'Untitled Folder',
        style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600),
      ),
      onTap: () {},
    );
  }
}

class ExplorerNoteTile extends StatelessWidget {
  final IsarNoteDocument note;
  const ExplorerNoteTile({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.note_alt_outlined, size: 20, color: Colors.blueAccent),
      title: Text(
        note.title ?? 'Untitled Note',
        style: GoogleFonts.outfit(fontSize: 14),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => NoteEditorPage(
              initialDocument: NoteMapper.toDomain(note),
            ),
          ),
        ).then((_) {
          if (context.mounted) {
            context.read<DashboardBloc>().add(LoadDashboard());
          }
        });
      },
    );
  }
}
