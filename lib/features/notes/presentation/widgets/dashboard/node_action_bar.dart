import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import '../../../data/models/isar_note_model.dart';

class NodeActionBar extends StatelessWidget {
  final String id;
  final bool isFolder;
  final String currentName;
  final Offset position;
  final VoidCallback onClose;

  const NodeActionBar({
    super.key,
    required this.id,
    required this.isFolder,
    required this.currentName,
    required this.position,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: onClose,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        Positioned(
          left: position.dx,
          top: position.dy,
          child: Material(
            color: Colors.transparent,
            child: TapRegion(
              onTapOutside: (_) => onClose(),
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
                              context.read<DashboardBloc>().add(RestoreItem(id: id, isFolder: isFolder));
                              onClose();
                            },
                            tooltip: 'Restore',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_forever, color: Colors.redAccent, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(PermanentlyDeleteItem(id: id, isFolder: isFolder));
                              onClose();
                            },
                            tooltip: 'Delete Permanently',
                          ),
                        ] else ...[
                          IconButton(
                            icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                            onPressed: () {
                              onClose();
                              _showRenameDialog(context);
                            },
                            tooltip: 'Rename',
                          ),
                          IconButton(
                            icon: const Icon(Icons.drive_file_move_outlined, color: Colors.white, size: 18),
                            onPressed: () {
                              onClose();
                              _showMoveDialog(context);
                            },
                            tooltip: 'Move',
                          ),
                          IconButton(
                            icon: const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(ToggleSelection(id: id, isFolder: isFolder));
                              onClose();
                            },
                            tooltip: 'Select',
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent, size: 18),
                            onPressed: () {
                              context.read<DashboardBloc>().add(DeleteNode(id: id, isFolder: isFolder));
                              onClose();
                            },
                            tooltip: 'Move to Trash',
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
      ],
    );
  }

  void _showRenameDialog(BuildContext context) {
    final TextEditingController controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(
          isFolder ? 'Rename Folder' : 'Rename Note',
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
                // Accessing Bloc from original context
                context.read<DashboardBloc>().add(RenameNode(
                      id: id,
                      newName: newName,
                      isFolder: isFolder,
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
                  // Root option
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, size: 20),
                    title: Text('Root Dashboard', style: GoogleFonts.outfit(fontSize: 14)),
                    onTap: () {
                      context.read<DashboardBloc>().add(MoveItemToFolder(
                        id: id,
                        targetFolderId: null,
                        isFolder: isFolder,
                      ));
                      Navigator.pop(dialogCtx);
                    },
                  ),
                  const Divider(),
                  // Folder tree
                  ...state.allFolders
                      .where((f) => f.parentFolderId == null)
                      .map((f) => _FolderPickerTile(
                            folder: f,
                            allFolders: state.allFolders,
                            depth: 0,
                            onMove: (targetId) {
                              context.read<DashboardBloc>().add(MoveItemToFolder(
                                id: id,
                                targetFolderId: targetId,
                                isFolder: isFolder,
                              ));
                              Navigator.pop(dialogCtx);
                            },
                            // Prevent moving into itself or its subtree if moving a folder
                            disabledId: isFolder ? id : null,
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
            )),
      ],
    );
  }
}
