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
          // Sort and Filter Notes
          var notes = List<IsarNoteDocument>.from(state.notes);
          
          // Filter by Tag
          if (state.activeTagFilter != null) {
            notes = notes.where((n) => n.tags.contains(state.activeTagFilter)).toList();
          }

          // Sort: Pinned first
          notes.sort((a, b) {
            if (a.isPinned && !b.isPinned) return -1;
            if (!a.isPinned && b.isPinned) return 1;
            return b.updatedAt?.compareTo(a.updatedAt ?? DateTime(0)) ?? 0;
          });

          if (state.isListView) {
            return SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => NoteListTile(note: notes[index]),
                  childCount: notes.length,
                ),
              ),
            );
          }

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
                (context, index) => NoteListItem(
                  key: ValueKey(notes[index].id),
                  note: notes[index],
                ),
                childCount: notes.length,
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
  bool _showLocalCheckbox = false; // Show checkbox on right click even if not in global selection mode

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    setState(() => _showLocalCheckbox = true);
    
    _overlayEntry = OverlayEntry(
      builder: (context) => NodeActionBar(
        id: widget.note.id!,
        isFolder: false,
        currentName: widget.note.title ?? '',
        onClose: () {
          _hideContextMenu();
          setState(() => _showLocalCheckbox = false);
        },
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
        final bool showCheckbox = isSelectionMode || _showLocalCheckbox;

        final item = TapRegion(
          groupId: 'node_actions', // Same group as the toolbar
          child: Container(
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
                            if (widget.note.tags.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: widget.note.tags.take(2).map((tag) => Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.03),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '#$tag',
                                    style: GoogleFonts.outfit(fontSize: 8, color: Colors.black45, fontWeight: FontWeight.bold),
                                  ),
                                )).toList(),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (widget.note.isPinned)
                    const Positioned(
                      top: 12,
                      left: 12,
                      child: Icon(Icons.push_pin, size: 14, color: Colors.blueAccent),
                    ),
                  if (widget.note.excludeFromBackup)
                     Positioned(
                      top: 12,
                      right: showCheckbox ? 44 : 12, // Offset if checkbox is visible
                      child: Icon(Icons.cloud_off, size: 14, color: Colors.black.withOpacity(0.3)),
                    ),
                  if (showCheckbox)
                    Positioned(
                      top: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          if (!isSelectionMode) {
                             context.read<DashboardBloc>().add(const SetSelectionMode(true));
                          }
                          context.read<DashboardBloc>().add(ToggleSelection(id: widget.note.id!, isFolder: false));
                          // Close the toolbar when selecting
                          _hideContextMenu();
                          setState(() => _showLocalCheckbox = false);
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
            onTap: () => _openNote(context, state),
            child: item,
          ),
        );
      },
    );
  }

  void _openNote(BuildContext context, DashboardState state) {
    if (state is DashboardLoaded && state.isSelectionMode) {
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
  }
}

class NoteListTile extends StatefulWidget {
  final IsarNoteDocument note;
  const NoteListTile({super.key, required this.note});

  @override
  State<NoteListTile> createState() => _NoteListTileState();
}

class _NoteListTileState extends State<NoteListTile> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    
    _overlayEntry = OverlayEntry(
      builder: (context) => NodeActionBar(
        id: widget.note.id!,
        isFolder: false,
        currentName: widget.note.title ?? '',
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
        
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: InkWell(
            onSecondaryTapDown: (_) => _showContextMenu(context),
            onTap: () => _openNote(context, state),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.blue.withOpacity(0.05) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.blue.withOpacity(0.3) : Colors.black.withOpacity(0.03)),
              ),
              child: Row(
                children: [
                  Icon(Icons.description_outlined, color: Colors.black26, size: 20),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.note.title ?? 'Untitled Note',
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        Text(
                          'Last edited ${DateFormatter.formatRelative(widget.note.updatedAt)}',
                          style: GoogleFonts.outfit(fontSize: 11, color: Colors.black38),
                        ),
                        if (widget.note.tags.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 4,
                            children: widget.note.tags.map((tag) => Text(
                              '#$tag',
                              style: GoogleFonts.outfit(fontSize: 9, color: Colors.blueAccent.withOpacity(0.6), fontWeight: FontWeight.bold),
                            )).toList(),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (widget.note.isPinned)
                    const Icon(Icons.push_pin, size: 14, color: Colors.blueAccent),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openNote(BuildContext context, DashboardState state) {
    if (state is DashboardLoaded && state.isSelectionMode) {
      context.read<DashboardBloc>().add(ToggleSelection(id: widget.note.id!, isFolder: false));
    } else if (state is DashboardLoaded && state.isTrashView) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Restore note to edit it')));
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => NoteEditorPage(initialDocument: NoteMapper.toDomain(widget.note))),
      ).then((_) {
        if (context.mounted) context.read<DashboardBloc>().add(const LoadDashboard(useCurrentFolder: true));
      });
    }
  }
}
