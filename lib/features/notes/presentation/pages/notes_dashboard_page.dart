import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/dashboard/folder_carousel.dart';
import '../widgets/dashboard/notes_grid.dart';
import '../widgets/dashboard/dashboard_toolbar.dart';
import '../widgets/dashboard/explorer_panel.dart';
import '../widgets/dashboard/left_sidebar.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../data/models/isar_note_model.dart';

class NotesDashboardPage extends StatefulWidget {
  const NotesDashboardPage({super.key});

  @override
  State<NotesDashboardPage> createState() => _NotesDashboardPageState();
}

class _NotesDashboardPageState extends State<NotesDashboardPage> {
  bool _isExplorerOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9), // Very clean off-white
      body: Row(
        children: [
          const LeftSidebar(),
          Expanded(
            child: Stack(
              children: [
                // Main Content
                SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // Header
                      SliverToBoxAdapter(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            final currentFolder = (state is DashboardLoaded) ? state.currentFolder : null;
                            final isRoot = currentFolder == null;

                            return Padding(
                              padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          state is DashboardLoaded && state.isTrashView ? 'RECYCLE BIN' : 
                                          (isRoot ? 'MY NOTES' : (currentFolder.name?.toUpperCase() ?? 'FOLDER')),
                                          style: GoogleFonts.outfit(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: 4,
                                            color: Colors.black.withOpacity(0.6),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            if (state is DashboardLoaded) ...[
                                              IconButton(
                                                onPressed: () => context.read<DashboardBloc>().add(ToggleViewMode()),
                                                icon: Icon(
                                                  state.isListView ? Icons.grid_view_rounded : Icons.view_list_rounded,
                                                  size: 20,
                                                  color: Colors.black38,
                                                ),
                                                tooltip: state.isListView ? 'Grid View' : 'List View',
                                              ),
                                            ],
                                            if (state is DashboardLoaded && state.isTrashView && state.notes.isNotEmpty)
                                              TextButton.icon(
                                                onPressed: () => context.read<DashboardBloc>().add(EmptyTrash()),
                                                icon: const Icon(Icons.delete_sweep_outlined, size: 18, color: Colors.redAccent),
                                                label: Text('Empty Trash', style: GoogleFonts.outfit(color: Colors.redAccent, fontSize: 12)),
                                              ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        // Home / Root
                                        _BreadcrumbItem(
                                          label: 'Home',
                                          isRoot: true,
                                          onTap: () => context.read<DashboardBloc>().add(const OpenFolder(null)),
                                        ),
                                        
                                        if (state is DashboardLoaded && state.isTrashView)
                                          const _BreadcrumbItem(
                                            label: 'Trash',
                                            onTap: null,
                                          )
                                        else if (!isRoot) ...(() {
                                          final path = <IsarFolder>[];
                                          IsarFolder? current = currentFolder;
                                          final allFolders = (state as DashboardLoaded).allFolders;
                                          
                                          while (current != null) {
                                            path.insert(0, current!);
                                            if (current!.parentFolderId == null) break;
                                            current = allFolders.where((f) => f.id == current!.parentFolderId).firstOrNull;
                                          }
                                          
                                          return path.map((IsarFolder f) => _BreadcrumbItem(
                                            id: f.id,
                                            label: f.name ?? 'Untitled',
                                            onTap: () => context.read<DashboardBloc>().add(OpenFolder(f.id)),
                                          ));
                                        })(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),

                      // Folders Section
                      SliverToBoxAdapter(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state is DashboardLoaded && state.folders.isNotEmpty) {
                              return const FoldersSection();
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),

                      // Notes Section Label
                      SliverToBoxAdapter(
                        child: BlocBuilder<DashboardBloc, DashboardState>(
                          builder: (context, state) {
                            if (state is DashboardLoaded && state.notes.isEmpty && state.folders.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 100),
                                  child: Column(
                                    children: [
                                      Icon(Icons.delete_outline, size: 64, color: Colors.black.withOpacity(0.1)),
                                      const SizedBox(height: 16),
                                      Text(
                                        state.isTrashView ? 'Trash is empty' : 'No items here',
                                        style: GoogleFonts.outfit(color: Colors.black26),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }
                            
                            return Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                              child: Text(
                                state is DashboardLoaded && state.isTrashView ? 'Deleted Items' : 'Recent Notes',
                                style: GoogleFonts.outfit(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Notes Grid
                      const NotesGridSection(),
                      
                      const SliverToBoxAdapter(child: SizedBox(height: 120)),
                    ],
                  ),
                ),

                // Bottom Compact Toolbar
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 30,
                  child: Center(
                    child: BottomCompactToolbar(
                      onExplorerToggle: () => setState(() => _isExplorerOpen = !_isExplorerOpen),
                      isExplorerOpen: _isExplorerOpen,
                    ),
                  ),
                ),

                // Explorer Panel
                AnimatedPositioned(
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeInOutCubic,
                  left: _isExplorerOpen ? 20 : -350,
                  top: 40,
                  bottom: 120,
                  child: ExplorerPanel(onClose: () => setState(() => _isExplorerOpen = false)),
                ),

                // Bulk Selection Toolbar
                BlocBuilder<DashboardBloc, DashboardState>(
                  builder: (context, state) {
                    if (state is DashboardLoaded && state.isSelectionMode) {
                      return Positioned(
                        left: 0,
                        right: 0,
                        bottom: 30,
                        child: Center(
                          child: _BulkSelectionToolbar(
                            selectedCount: state.selectedNoteIds.length + state.selectedFolderIds.length,
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _BreadcrumbItem extends StatelessWidget {
  final String? id;
  final String label;
  final VoidCallback? onTap;
  final bool isRoot;

  const _BreadcrumbItem({
    this.id,
    required this.label,
    this.onTap,
    this.isRoot = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isRoot) 
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Icon(Icons.chevron_right, size: 14, color: Colors.black.withOpacity(0.2)),
          ),
        if (onTap == null)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            child: Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          )
        else
          DragTarget<Map<String, dynamic>>(
          onAcceptWithDetails: (details) {
            final data = details.data;
            context.read<DashboardBloc>().add(MoveItemToFolder(
              id: data['id'],
              targetFolderId: id,
              isFolder: data['isFolder'],
            ));
          },
          builder: (context, candidateData, rejectedData) {
            final isHovering = candidateData.isNotEmpty;
            return InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(4),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                child: Text(
                  label,
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    fontWeight: isHovering ? FontWeight.bold : FontWeight.w500,
                    color: isHovering ? Colors.blue : Colors.black.withOpacity(0.4),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _BulkSelectionToolbar extends StatelessWidget {
  final int selectedCount;
  const _BulkSelectionToolbar({required this.selectedCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF333333),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '$selectedCount Selected',
            style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 20),
          _ToolbarButton(
            icon: Icons.drive_file_move_outlined,
            label: 'Move',
            onTap: () => _showBulkMoveDialog(context),
          ),
          const SizedBox(width: 12),
          _ToolbarButton(
            icon: Icons.delete_outline_rounded,
            label: 'Delete',
            color: Colors.redAccent,
            onTap: () {
              context.read<DashboardBloc>().add(BulkDelete());
            },
          ),
          const VerticalDivider(color: Colors.white24, width: 24, indent: 8, endIndent: 8),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 20),
            onPressed: () => context.read<DashboardBloc>().add(ClearSelection()),
          ),
        ],
      ),
    );
  }

  void _showBulkMoveDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogCtx) => BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is! DashboardLoaded) return const SizedBox.shrink();

          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
            title: Text('Move Selection to...', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: SizedBox(
              width: 300,
              height: 400,
              child: ListView(
                children: [
                  ListTile(
                    leading: const Icon(Icons.dashboard_outlined, size: 20),
                    title: Text('Root Dashboard', style: GoogleFonts.outfit(fontSize: 14)),
                    onTap: () {
                      context.read<DashboardBloc>().add(const BulkMove(targetFolderId: null));
                      Navigator.pop(dialogCtx);
                    },
                  ),
                  const Divider(),
                  ...state.allFolders.where((f) => f.parentFolderId == null).map((f) => _BulkMoveTile(
                    folder: f,
                    allFolders: state.allFolders,
                    depth: 0,
                    onMove: (targetId) {
                      context.read<DashboardBloc>().add(BulkMove(targetFolderId: targetId));
                      Navigator.pop(dialogCtx);
                    },
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

class _ToolbarButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  const _ToolbarButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        child: Row(
          children: [
            Icon(icon, color: color, size: 18),
            const SizedBox(width: 6),
            Text(label, style: GoogleFonts.outfit(color: color, fontSize: 13, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _BulkMoveTile extends StatelessWidget {
  final IsarFolder folder;
  final List<IsarFolder> allFolders;
  final int depth;
  final Function(String) onMove;

  const _BulkMoveTile({
    required this.folder,
    required this.allFolders,
    required this.depth,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    final children = allFolders.where((f) => f.parentFolderId == folder.id).toList();
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.only(left: 16.0 + (depth * 20.0)),
          leading: const Icon(Icons.folder_outlined, size: 20, color: Colors.amber),
          title: Text(folder.name ?? 'Untitled', style: GoogleFonts.outfit(fontSize: 14)),
          onTap: () => onMove(folder.id!),
        ),
        ...children.map((child) => _BulkMoveTile(
          folder: child,
          allFolders: allFolders,
          depth: depth + 1,
          onMove: onMove,
        )),
      ],
    );
  }
}
