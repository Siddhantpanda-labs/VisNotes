import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/dashboard/dashboard_bloc.dart';
import '../../data/models/isar_note_model.dart';
import 'note_editor_page.dart';

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
      body: Stack(
        children: [
          // Main Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(30, 40, 30, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MY NOTES',
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                            color: Colors.black.withOpacity(0.3),
                          ),
                        ),
                        Text(
                          'All Documents',
                          style: GoogleFonts.outfit(
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Folders Section
                SliverToBoxAdapter(
                  child: _FoldersSection(),
                ),

                // Notes Section Label
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                    child: Text(
                      'Recent Notes',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ),

                // Notes Grid
                const _NotesGridSection(),
                
                // Bottom Padding for Toolbar
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
              child: _BottomCompactToolbar(
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
            child: _ExplorerPanel(onClose: () => setState(() => _isExplorerOpen = false)),
          ),
        ],
      ),
    );
  }
}

class _FoldersSection extends StatelessWidget {
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
                return _FolderItem(folder: state.folders[index]);
              },
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _FolderItem extends StatefulWidget {
  final IsarFolder folder;
  const _FolderItem({required this.folder});

  @override
  State<_FolderItem> createState() => _FolderItemState();
}

class _FolderItemState extends State<_FolderItem> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _NodeActionBar(
        id: widget.folder.id!,
        isFolder: true,
        currentName: widget.folder.name ?? '',
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: GestureDetector(
        onSecondaryTapDown: (_) => _showContextMenu(context),
        child: Container(
          width: 140,
          height: 100,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
            border: Border.all(color: Colors.black.withOpacity(0.05)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.folder, color: Colors.amber, size: 40),
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
      ),
    );
  }
}

class _NotesGridSection extends StatelessWidget {
  const _NotesGridSection();

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
                mainAxisSpacing: 30, // Increased spacing
                crossAxisSpacing: 20,
                childAspectRatio: 0.8,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _NoteListItem(note: state.notes[index]),
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

class _NoteListItem extends StatefulWidget {
  final IsarNoteDocument note;
  const _NoteListItem({required this.note});

  @override
  State<_NoteListItem> createState() => _NoteListItemState();
}

class _NoteListItemState extends State<_NoteListItem> {
  OverlayEntry? _overlayEntry;

  void _showContextMenu(BuildContext context) {
    _hideContextMenu();
    
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => _NodeActionBar(
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
    return GestureDetector(
      onSecondaryTapDown: (_) => _showContextMenu(context),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const NoteEditorPage()),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
          border: Border.all(color: Colors.black.withOpacity(0.05)),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Column(
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
                      'Last edited today',
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
        ),
      ),
    );
  }
}

class _BottomCompactToolbar extends StatelessWidget {
  final VoidCallback onExplorerToggle;
  final bool isExplorerOpen;

  const _BottomCompactToolbar({
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
          _ToolbarActionIcon(icon: Icons.search, onTap: () {}),
          const SizedBox(width: 5),
          _ToolbarActionIcon(
            icon: Icons.grid_view_rounded,
            isActive: isExplorerOpen,
            onTap: onExplorerToggle,
          ),
          const SizedBox(width: 5),
          const _CompactWobblyAddButton(),
        ],
      ),
    );
  }
}

class _ToolbarActionIcon extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  const _ToolbarActionIcon({
    required this.icon,
    required this.onTap,
    this.isActive = false,
  });

  @override
  State<_ToolbarActionIcon> createState() => _ToolbarActionIconState();
}

class _ToolbarActionIconState extends State<_ToolbarActionIcon> {
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

class _CompactWobblyAddButton extends StatefulWidget {
  const _CompactWobblyAddButton();

  @override
  State<_CompactWobblyAddButton> createState() => _CompactWobblyAddButtonState();
}

class _CompactWobblyAddButtonState extends State<_CompactWobblyAddButton> with SingleTickerProviderStateMixin {
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
                    _MenuOption(
                      icon: Icons.gesture,
                      label: 'Vector Note',
                      onTap: () {
                        context.read<DashboardBloc>().add(const CreateDocument(x: 0, y: 0, type: 'vector'));
                        _hideMenu();
                      },
                    ),
                    _MenuOption(
                      icon: Icons.text_fields,
                      label: 'Text Note',
                      onTap: () {
                        context.read<DashboardBloc>().add(const CreateDocument(x: 0, y: 0, type: 'text'));
                        _hideMenu();
                      },
                    ),
                    _MenuOption(
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

class _ExplorerPanel extends StatelessWidget {
  final VoidCallback onClose;
  const _ExplorerPanel({required this.onClose});

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
                      ...state.folders.map((f) => _ExplorerFolderTile(folder: f)),
                      ...state.notes.map((n) => _ExplorerNoteTile(note: n)),
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

class _ExplorerFolderTile extends StatelessWidget {
  final IsarFolder folder;
  const _ExplorerFolderTile({required this.folder});

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

class _ExplorerNoteTile extends StatelessWidget {
  final IsarNoteDocument note;
  const _ExplorerNoteTile({required this.note});

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
          MaterialPageRoute(builder: (context) => const NoteEditorPage()),
        );
      },
    );
  }
}

class _NodeActionBar extends StatelessWidget {
  final String id;
  final bool isFolder;
  final String currentName;
  final Offset position;
  final VoidCallback onClose;

  const _NodeActionBar({
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
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.white, size: 18),
                      onPressed: () {
                        onClose();
                        _showRenameDialog(context);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.open_with, color: Colors.white, size: 18),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 18),
                      onPressed: () {
                        onClose();
                        context.read<DashboardBloc>().add(DeleteNode(id: id, isFolder: isFolder));
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showRenameDialog(BuildContext context) {
    final controller = TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rename ${isFolder ? 'Folder' : 'Note'}'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter new name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              context.read<DashboardBloc>().add(RenameNode(
                    id: id,
                    newName: controller.text,
                    isFolder: isFolder,
                  ));
              Navigator.pop(context);
            },
            child: const Text('Rename'),
          ),
        ],
      ),
    );
  }
}
