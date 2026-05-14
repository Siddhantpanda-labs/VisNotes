import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../bloc/dashboard/dashboard_bloc.dart';

class BottomCompactToolbar extends StatelessWidget {
  final VoidCallback onExplorerToggle;
  final bool isExplorerOpen;

  const BottomCompactToolbar({
    super.key,
    required this.onExplorerToggle,
    required this.isExplorerOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
        border: Border.all(color: Colors.black.withOpacity(0.05)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          ToolbarActionIcon(icon: Icons.search, onTap: () {}),
          const SizedBox(width: 5),
          ToolbarActionIcon(
            icon: Icons.grid_view_rounded,
            isActive: isExplorerOpen,
            onTap: onExplorerToggle,
          ),
          const SizedBox(width: 5),
          const CompactWobblyAddButton(),
        ],
      ),
    );
  }
}

class ToolbarActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const ToolbarActionIcon({
    super.key,
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<ToolbarActionIcon> createState() => _ToolbarActionIconState();
}

class _ToolbarActionIconState extends State<ToolbarActionIcon> {
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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: widget.isActive 
              ? Colors.black 
              : (_isHovered ? Colors.black.withOpacity(0.05) : Colors.transparent),
            shape: BoxShape.circle,
          ),
          child: Icon(
            widget.icon, 
            color: widget.isActive ? Colors.white : Colors.black54, 
            size: 22,
          ),
        ),
      ),
    );
  }
}

class CompactWobblyAddButton extends StatefulWidget {
  const CompactWobblyAddButton({super.key});

  @override
  State<CompactWobblyAddButton> createState() => _CompactWobblyAddButtonState();
}

class _CompactWobblyAddButtonState extends State<CompactWobblyAddButton> with SingleTickerProviderStateMixin {
  late AnimationController _wobbleController;
  bool _isHovered = false;
  bool _isMenuOpen = false;
  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void dispose() {
    _hideMenu();
    _wobbleController.dispose();
    super.dispose();
  }

  void _showMenu() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          GestureDetector(
            onTap: _hideMenu,
            child: Container(color: Colors.transparent),
          ),
          Positioned(
            left: offset.dx - 60,
            bottom: MediaQuery.of(context).size.height - offset.dy + 10,
            child: Material(
              color: Colors.transparent,
              child: Container(
                width: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                  border: Border.all(color: Colors.black.withOpacity(0.05)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MenuOption(
                      icon: Icons.gesture,
                      label: 'Vector Note',
                      onTap: () {
                        context.read<DashboardBloc>().add(const CreateDocument(x: 0, y: 0, type: 'vector'));
                        _hideMenu();
                      },
                    ),
                    MenuOption(
                      icon: Icons.text_fields,
                      label: 'Text Note',
                      onTap: () {
                        context.read<DashboardBloc>().add(const CreateDocument(x: 0, y: 0, type: 'text'));
                        _hideMenu();
                      },
                    ),
                    MenuOption(
                      icon: Icons.folder_outlined,
                      label: 'New Folder',
                      onTap: () {
                        context.read<DashboardBloc>().add(const CreateFolder(x: 0, y: 0));
                        _hideMenu();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isMenuOpen = true);
  }

  void _hideMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (mounted) setState(() => _isMenuOpen = false);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: () {
          if (_isMenuOpen) _hideMenu(); else _showMenu();
        },
        child: AnimatedBuilder(
          animation: _wobbleController,
          builder: (context, child) {
            return Transform.scale(
              scale: _isHovered ? 1.1 : 1.0,
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: AnimatedRotation(
                  duration: const Duration(milliseconds: 300),
                  turns: _isMenuOpen ? 0.125 : 0,
                  child: const Icon(Icons.add, color: Colors.white, size: 24),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class MenuOption extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const MenuOption({super.key, required this.icon, required this.label, required this.onTap});

  @override
  State<MenuOption> createState() => _MenuOptionState();
}

class _MenuOptionState extends State<MenuOption> {
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: _isHovered ? Colors.black.withOpacity(0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
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
