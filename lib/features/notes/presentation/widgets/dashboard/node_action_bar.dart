import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../../data/models/isar_note_model.dart';

class NodeActionBar extends StatefulWidget {
  final String id;
  final bool isFolder;
  final String currentName;
  final VoidCallback onClose;

  const NodeActionBar({
    super.key,
    required this.id,
    required this.isFolder,
    required this.currentName,
    required this.onClose,
  });

  @override
  State<NodeActionBar> createState() => _NodeActionBarState();
}

class _NodeActionBarState extends State<NodeActionBar> {
  OverlayEntry? _moreMenuEntry;

  void _hideMoreMenu() {
    _moreMenuEntry?.remove();
    _moreMenuEntry = null;
  }

  void _showMoreOptions(BuildContext context) {
    _hideMoreMenu();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _moreMenuEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideMoreMenu,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: offset.dx + renderBox.size.width - 200, // Align towards right
            bottom: MediaQuery.of(context).size.height - offset.dy + 10,
            child: Material(
              color: Colors.transparent,
              child: TapRegion(
                groupId: 'node_actions', // Link with the toolbar and note card
                child: Container(
                  width: 220,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(color: Colors.black.withOpacity(0.05)),
                  ),
                  child: BlocBuilder<DashboardBloc, DashboardState>(
                    builder: (context, state) {
                      bool isExcluded = false;
                      if (state is DashboardLoaded && !widget.isFolder) {
                        isExcluded = state.notes.any((n) => n.id == widget.id && n.excludeFromBackup);
                      }

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!widget.isFolder)
                            _MenuOption(
                              icon: isExcluded ? Icons.cloud_done_outlined : Icons.cloud_off_outlined,
                              label: isExcluded ? 'Include in Backup' : 'Exclude from Backup',
                              onTap: () {
                                // Add event FIRST
                                context.read<DashboardBloc>().add(ToggleBackupExclusion(id: widget.id));
                                // Then hide menu and toolbar
                                _hideMoreMenu();
                                widget.onClose();
                              },
                            ),
                          if (!widget.isFolder)
                            _MenuOption(
                              icon: Icons.lock_outline,
                              label: (state is DashboardLoaded && state.notes.any((n) => n.id == widget.id && n.isLocked)) 
                                  ? 'Unlock Note' : 'Lock Note',
                              onTap: () {
                                context.read<DashboardBloc>().add(ToggleNoteLock(id: widget.id));
                                _hideMoreMenu();
                                widget.onClose();
                              },
                            ),
                          _MenuOption(
                            icon: Icons.file_download_outlined,
                            label: 'Export Note',
                            onTap: () {
                              _hideMoreMenu();
                              widget.onClose();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Export coming soon!')),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_moreMenuEntry!);
  }

  @override
  void dispose() {
    _hideMoreMenu();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          bottom: 100,
          left: 260,
          right: 0,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: TapRegion(
                groupId: 'node_actions',
                onTapOutside: (_) => widget.onClose(),
                child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF333333),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    final bool isTrash = state is DashboardLoaded && state.isTrashView;
                    
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isTrash) ...[
                          IconButton(
                            icon: const Icon(Icons.restore, color: Colors.greenAccent, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(RestoreItem(id: widget.id, isFolder: widget.isFolder));
                              widget.onClose();
                            },
                            tooltip: 'Restore',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(PermanentlyDeleteItem(id: widget.id, isFolder: widget.isFolder));
                              widget.onClose();
                            },
                            tooltip: 'Delete Permanently',
                          ),
                        ] else ...[
                          IconButton(
                            icon: BlocBuilder<DashboardBloc, DashboardState>(
                              builder: (context, state) {
                                bool isPinned = false;
                                if (state is DashboardLoaded) {
                                  if (widget.isFolder) {
                                    isPinned = state.folders.any((f) => f.id == widget.id && f.isPinned);
                                  } else {
                                    isPinned = state.notes.any((n) => n.id == widget.id && n.isPinned);
                                  }
                                }
                                return Icon(
                                  isPinned ? Icons.push_pin : Icons.push_pin_outlined, 
                                  color: isPinned ? Colors.blueAccent : Colors.white, 
                                  size: 18
                                );
                              },
                            ),
                            onPressed: () {
                              context.read<DashboardBloc>().add(TogglePinNode(id: widget.id, isFolder: widget.isFolder));
                              widget.onClose();
                            },
                            tooltip: 'Pin',
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                            onPressed: () {
                              widget.onClose();
                              _showRenameDialog(context);
                            },
                            tooltip: 'Rename',
                          ),
                          if (widget.isFolder)
                            IconButton(
                              icon: const Icon(Icons.palette_outlined, color: Colors.white, size: 18),
                              onPressed: () {
                                widget.onClose();
                                _showColorIconPicker(context);
                              },
                              tooltip: 'Customize',
                            ),
                          IconButton(
                            icon: const Icon(Icons.label_outline_rounded, color: Colors.white, size: 18),
                            onPressed: () {
                              widget.onClose();
                              _showTagDialog(context);
                            },
                            tooltip: 'Tags',
                          ),
                          IconButton(
                            icon: const Icon(Icons.drive_file_move_outlined, color: Colors.white, size: 18),
                            onPressed: () {
                              widget.onClose();
                              _showMoveDialog(context);
                            },
                            tooltip: 'Move',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(DeleteNode(id: widget.id, isFolder: widget.isFolder));
                              widget.onClose();
                            },
                            tooltip: 'Move to Trash',
                          ),
                          // "..." dot to the right
                          IconButton(
                            icon: const Icon(Icons.more_horiz_rounded, color: Colors.white, size: 18),
                            onPressed: () => _showMoreOptions(context),
                            tooltip: 'More',
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
      ],
    );
  }

  // --- Helper Dialogs ---

  void _showColorIconPicker(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Customize Folder', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Color', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                0xFFFFA000, 0xFFF44336, 0xFFE91E63, 0xFF9C27B0, 0xFF673AB7, 
                0xFF3F51B5, 0xFF2196F3, 0xFF00BCD4, 0xFF009688, 0xFF4CAF50
              ].map((color) => GestureDetector(
                onTap: () {
                  context.read<DashboardBloc>().add(UpdateFolderCustomization(id: widget.id, colorValue: color));
                  Navigator.pop(ctx);
                },
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Color(color),
                    shape: BoxShape.circle,
                  ),
                ),
              )).toList(),
            ),
            const SizedBox(height: 24),
            Text('Icon', style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                Icons.folder, Icons.work, Icons.home, Icons.favorite, Icons.star,
                Icons.book, Icons.code, Icons.image, Icons.music_note, Icons.shopping_bag
              ].map((icon) => IconButton(
                onPressed: () {
                  context.read<DashboardBloc>().add(UpdateFolderCustomization(id: widget.id, iconCodePoint: icon.codePoint));
                  Navigator.pop(ctx);
                },
                icon: Icon(icon, color: Colors.black54),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showTagDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is! DashboardLoaded) return const SizedBox.shrink();
          
          final currentTags = widget.isFolder 
              ? state.folders.firstWhere((f) => f.id == widget.id).tags 
              : state.notes.firstWhere((n) => n.id == widget.id).tags;

          return AlertDialog(
            title: Text('Tags', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 300,
              child: state.tags.isEmpty 
                ? const Text('No tags created yet.')
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: state.tags.map((tag) {
                      final isTagged = currentTags.contains(tag.name);
                      return CheckboxListTile(
                        title: Text(tag.name!, style: GoogleFonts.outfit()),
                        value: isTagged,
                        activeColor: Color(tag.colorValue),
                        onChanged: (val) {
                          context.read<DashboardBloc>().add(ToggleTagOnNode(
                            id: widget.id, 
                            tag: tag.name!, 
                            isFolder: widget.isFolder
                          ));
                        },
                        secondary: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(color: Color(tag.colorValue), shape: BoxShape.circle),
                        ),
                      );
                    }).toList(),
                  ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
            ],
          );
        },
      ),
    );
  }

  void _showRenameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: widget.currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          widget.isFolder ? 'Rename Folder' : 'Rename Note',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Enter new name',
            filled: true,
            fillColor: Colors.black.withOpacity(0.05),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(color: Colors.black54)),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                context.read<DashboardBloc>().add(RenameNode(
                      id: widget.id,
                      newName: newName,
                      isFolder: widget.isFolder,
                    ));
              }
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }

  void _showMoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is! DashboardLoaded) return const SizedBox.shrink();

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text(
              'Move to...',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            content: SizedBox(
              width: 300,
              height: 400,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, size: 20),
                    title: Text('Root Dashboard', style: GoogleFonts.outfit(fontSize: 14)),
                    onTap: () {
                      context.read<DashboardBloc>().add(MoveItemToFolder(
                        id: widget.id,
                        targetFolderId: null,
                        isFolder: widget.isFolder,
                      ));
                      Navigator.pop(dialogCtx);
                    },
                  ),
                  const Divider(),
                  ...state.allFolders
                      .where((f) => f.parentFolderId == null)
                      .map((f) => _FolderPickerTile(
                            folder: f,
                            allFolders: state.allFolders,
                            depth: 0,
                            onMove: (targetId) {
                              context.read<DashboardBloc>().add(MoveItemToFolder(
                                id: widget.id,
                                targetFolderId: targetId,
                                isFolder: widget.isFolder,
                              ));
                              Navigator.pop(dialogCtx);
                            },
                            disabledId: widget.isFolder ? widget.id : null,
                          )),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuOption({required this.icon, required this.label, required this.onTap});

  @override
  State<_MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<_MenuOption> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.black.withOpacity(0.05) : Colors.transparent,
          ),
          child: Row(
            children: [
              Icon(widget.icon, size: 18, color: Colors.black87),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FolderPickerTile extends StatelessWidget {
  final IsarFolder folder;
  final List<IsarFolder> allFolders;
  final int depth;
  final Function(String) onMove;
  final String? disabledId;

  const _FolderPickerTile({
    required this.folder,
    required this.allFolders,
    required this.depth,
    required this.onMove,
    this.disabledId,
  });

  @override
  Widget build(BuildContext context) {
    if (folder.id == disabledId) return const SizedBox.shrink();
    final children = allFolders.where((IsarFolder f) => f.parentFolderId == folder.id).toList();

    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + (depth * 20.0)),
          leading: const Icon(Icons.folder_outlined, size: 20, color: Colors.amber),
          title: Text(
            folder.name ?? 'Untitled',
            style: GoogleFonts.outfit(fontSize: 14),
          ),
          onTap: () => onMove(folder.id!),
        ),
        ...children.map((child) => _FolderPickerTile(
              folder: child,
              allFolders: allFolders,
              depth: depth + 1,
              onMove: onMove,
              disabledId: disabledId,
            ),
        ),
      ],
    );
  }
}
