import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/models/isar_note_model.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';
import 'node_action_bar.dart';

class FoldersSection extends StatelessWidget {
  const FoldersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (context, state) {
        if (state is DashboardLoaded) {
          if (state.folders.isEmpty) return const SizedBox.shrink();
          return SizedBox(
            height: 140,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: state.folders.length,
              itemBuilder: (context, index) {
                return FolderItem(folder: state.folders[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class FolderItem extends StatefulWidget {
  final IsarFolder folder;
  const FolderItem({super.key, required this.folder});

  @override
  State<FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<FolderItem> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => NodeActionBar(
        id: widget.folder.id!,
        isFolder: true,
        currentName: widget.folder.name ?? '',
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
        final bool isSelected = state is DashboardLoaded && state.selectedFolderIds.contains(widget.folder.id);
        final bool isSelectionMode = state is DashboardLoaded && state.isSelectionMode;

        final folderColor = widget.folder.colorValue != null ? Color(widget.folder.colorValue!) : Colors.amber;
        final folderIcon = widget.folder.iconCodePoint != null 
            ? IconData(widget.folder.iconCodePoint!, fontFamily: 'MaterialIcons') 
            : Icons.folder;

        final item = Container(
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: isSelected ? Colors.blue.withOpacity(0.5) : 
                     (widget.folder.colorValue != null ? folderColor.withOpacity(0.3) : Colors.black.withOpacity(0.05)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Stack(
            children: [
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(folderIcon, color: folderColor, size: 40),
                    const SizedBox(height: 8),
                    Text(
                      widget.folder.name ?? 'Untitled',
                      style: GoogleFonts.outfit(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (widget.folder.isPinned)
                const Positioned(
                  top: 12,
                  left: 12,
                  child: Icon(Icons.push_pin, size: 14, color: Colors.blueAccent),
                ),
              if (isSelectionMode)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected ? Colors.blue : Colors.black26,
                        width: 2,
                      ),
                    ),
                    child: isSelected 
                      ? const Icon(Icons.check, size: 12, color: Colors.white)
                      : null,
                  ),
                ),
            ],
          ),
        );

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: DragTarget<Map<String, dynamic>>(
            onWillAcceptWithDetails: (details) => details.data['id'] != widget.folder.id,
            onAcceptWithDetails: (details) {
              final data = details.data;
              context.read<DashboardBloc>().add(MoveItemToFolder(
                id: data['id'],
                targetFolderId: widget.folder.id,
                isFolder: data['isFolder'],
              ));
            },
            builder: (context, candidateData, rejectedData) {
              final isHovering = candidateData.isNotEmpty;
              
              return AnimatedScale(
                scale: isHovering ? 1.05 : 1.0,
                duration: const Duration(milliseconds: 200),
                child: Draggable<Map<String, dynamic>>(
                  data: {'id': widget.folder.id, 'isFolder': true},
                  feedback: Material(
                    color: Colors.transparent,
                    child: SizedBox(
                      width: 100, // Smaller feedback
                      height: 80,
                      child: Opacity(opacity: 0.8, child: item),
                    ),
                  ),
                  childWhenDragging: Opacity(opacity: 0.3, child: item),
                  child: GestureDetector(
                    onSecondaryTapDown: (_) => _showContextMenu(context),
                    onTap: () {
                      if (isSelectionMode) {
                        context.read<DashboardBloc>().add(ToggleSelection(id: widget.folder.id!, isFolder: true));
                      } else if (state is DashboardLoaded && state.isTrashView) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Restore folder to open it')),
                        );
                      } else {
                        context.read<DashboardBloc>().add(OpenFolder(widget.folder.id));
                      }
                    },
                    child: Container(
                      decoration: isHovering ? BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue.withOpacity(0.5), width: 2),
                      ) : null,
                      child: item,
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
