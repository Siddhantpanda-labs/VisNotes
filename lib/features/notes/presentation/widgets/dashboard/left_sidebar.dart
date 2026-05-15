import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';

class LeftSidebar extends StatelessWidget {
  const LeftSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          right: BorderSide(color: Colors.black.withOpacity(0.05)),
        ),
      ),
      child: Column(
        children: [
          // App Logo / Title
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 32),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.auto_awesome_mosaic, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 12),
                Text(
                  'VisNotes',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  ),
                ),
              ],
            ),
          ),

          // Primary Navigation
          BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              final isTrash = state is DashboardLoaded && state.isTrashView;
              final isHome = state is DashboardLoaded && state.currentFolderId == null && !isTrash;

              return Column(
                children: [
                  _SidebarItem(
                    icon: Icons.dashboard_outlined,
                    activeIcon: Icons.dashboard,
                    label: 'Home',
                    isActive: isHome,
                    onTap: () {
                       context.read<DashboardBloc>().add(const OpenFolder(null));
                    },
                  ),
                  _SidebarItem(
                    icon: Icons.delete_outline_rounded,
                    activeIcon: Icons.delete_rounded,
                    label: 'Recycle Bin',
                    isActive: isTrash, 
                    onTap: () {
                       context.read<DashboardBloc>().add(LoadTrash());
                    },
                  ),
                ],
              );
            },
          ),

          const SizedBox(height: 32),
          
          // Tags Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TAGS',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: Colors.black38,
                  ),
                ),
                IconButton(
                  onPressed: () => _showCreateTagDialog(context),
                  icon: const Icon(Icons.add, size: 16, color: Colors.black38),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),

          Expanded(
            child: BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                if (state is DashboardLoaded) {
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: state.tags.length,
                    itemBuilder: (context, index) {
                      final tag = state.tags[index];
                      final isSelected = state.activeTagFilter == tag.name;
                      return _TagItem(
                        tag: tag,
                        isSelected: isSelected,
                        onTap: () {
                          context.read<DashboardBloc>().add(FilterByTag(isSelected ? null : tag.name));
                        },
                        onDelete: () {
                          context.read<DashboardBloc>().add(DeleteTag(id: tag.id!));
                        },
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showCreateTagDialog(BuildContext context) {
    final controller = TextEditingController();
    int selectedColor = 0xFF2196F3;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Create Tag', style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: controller,
                  autofocus: true,
                  decoration: const InputDecoration(hintText: 'Tag name'),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    0xFFF44336, 0xFF4CAF50, 0xFF2196F3, 0xFFFFC107, 0xFF9C27B0
                  ].map((color) {
                    final isSelected = selectedColor == color;
                    return GestureDetector(
                      onTap: () => setState(() => selectedColor = color),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        width: isSelected ? 36 : 30,
                        height: isSelected ? 36 : 30,
                        decoration: BoxDecoration(
                          color: Color(color),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? Colors.black : Colors.black12,
                            width: isSelected ? 3 : 1,
                          ),
                          boxShadow: isSelected ? [
                            BoxShadow(color: Color(color).withOpacity(0.4), blurRadius: 8, offset: const Offset(0, 4))
                          ] : null,
                        ),
                        child: isSelected 
                          ? const Icon(Icons.check, size: 18, color: Colors.white)
                          : null,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    context.read<DashboardBloc>().add(CreateTag(
                      name: controller.text.trim(),
                      colorValue: selectedColor,
                    ));
                  }
                  Navigator.pop(ctx);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Create'),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isActive ? Colors.black.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                isActive ? activeIcon : icon,
                size: 20,
                color: isActive ? Colors.black : Colors.black45,
              ),
              const SizedBox(width: 16),
              Text(
                label,
                style: GoogleFonts.outfit(
                  fontSize: 15,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  color: isActive ? Colors.black : Colors.black45,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  final dynamic tag;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _TagItem({
    required this.tag,
    required this.isSelected,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(tag.colorValue).withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: Color(tag.colorValue),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          tag.name,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                            color: isSelected ? Color(tag.colorValue) : Colors.black54,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.close, size: 14, color: Colors.black26),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
