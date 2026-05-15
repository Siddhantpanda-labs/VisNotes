import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/isar_note_model.dart';
import '../../../data/mappers/note_mapper.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../pages/note_editor_page.dart';
import 'package:visnotes/core/utils/date_formatter.dart';
import 'node_action_bar.dart';

class NotesGridSection extends StatelessWidget {
  const NotesGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          return SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 220,
                mainAxisSpacing: 30,
                crossAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => NoteListItem(note: state.notes[index]),
                childCount: state.notes.length,
              ),
            ),
          );
        }
        return const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class NoteListItem extends StatefulWidget {
  final IsarNoteDocument note;
  const NoteListItem({super.key, required this.note});

  @override
  State<NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<NoteListItem> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => NodeActionBar(
        id: widget.note.id!,
        isFolder: false,
        currentName: widget.note.title ?? '',
        position: Offset(offset.dx + (size.width / 2) - 80, offset.dy - 60),
        onClose: _hideContextMenu,
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _hideContextMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _hideContextMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        final bool isSelected = state is DashboardLoaded && state.selectedNoteIds.contains(widget.note.id);
        final bool isSelectionMode = state is DashboardLoaded && state.isSelectionMode;

        final item = Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.black.withOpacity(0.04),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.blue.withOpacity(0.5) : Colors.black.withOpacity(0.05),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Container(
                        color: const Color(0xFFFAFAFA),
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: Icon(Icons.description_outlined, color: Colors.black.withOpacity(0.05), size: 40),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.note.title ?? 'Untitled Note',
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Edited ${DateFormatter.formatRelative(widget.note.updatedAt)}',
                            style: GoogleFonts.outfit(
                              fontSize: 10,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (isSelectionMode)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: GestureDetector(
                      onTap: () {
                        context.read<DashboardBloc>().add(ToggleSelection(id: widget.note.id!, isFolder: false));
                      },
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.blue : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.blue : Colors.black26,
                            width: 2,
                          ),
                        ),
                        child: isSelected 
                          ? const Icon(Icons.check, size: 16, color: Colors.white)
                          : null,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );

        return Draggable<Map<String, dynamic>>(
          data: {'id': widget.note.id, 'isFolder': false},
          feedback: Material(
            color: Colors.transparent,
            child: SizedBox(
              width: 120,
              height: 100,
              child: Opacity(opacity: 0.8, child: item),
            ),
          ),
          childWhenDragging: Opacity(opacity: 0.3, child: item),
          child: GestureDetector(
            onSecondaryTapDown: (_) => _showContextMenu(context),
            onTap: () {
              if (isSelectionMode) {
                context.read<DashboardBloc>().add(ToggleSelection(id: widget.note.id!, isFolder: false));
              } else if (state is DashboardLoaded && state.isTrashView) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restore note to edit it')),
                );
              } else {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => NoteEditorPage(
                      initialDocument: NoteMapper.toDomain(widget.note),
                    ),
                  ),
                ).then((_) {
                  if (context.mounted) {
                    context.read<DashboardBloc>().add(const LoadDashboard(useCurrentFolder: true));
                  }
                });
              }
            },
            child: item,
          ),
        );
      },
    );
  }
}
