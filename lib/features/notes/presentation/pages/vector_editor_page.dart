import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';

import '../bloc/vector_editor/vector_editor_bloc.dart';
import '../bloc/vector_editor/vector_editor_event.dart';
import '../bloc/vector_editor/vector_editor_state.dart';
import '../../data/repositories/vector_note_repository.dart';
import '../../domain/entities/vector_canvas/vector_note_document.dart';
import '../widgets/vector_canvas/vector_canvas_widget.dart';

class VectorEditorPage extends StatefulWidget {
  final String noteId;
  final String noteTitle;

  const VectorEditorPage({
    super.key,
    required this.noteId,
    required this.noteTitle,
  });

  @override
  State<VectorEditorPage> createState() => _VectorEditorPageState();
}

class _VectorEditorPageState extends State<VectorEditorPage> {
  late final TextEditingController _titleController;
  bool _isEditingTitle = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.noteTitle);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<VectorEditorBloc>(
      create: (context) => VectorEditorBloc(
        vectorNoteRepository: RepositoryProvider.of<VectorNoteRepository>(context),
      )..add(LoadVectorNote(
          VectorNoteDocument(
            id: widget.noteId,
            title: widget.noteTitle,
            elements: const [],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )),
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: const Color(0xFFF8FAFC),
            body: Stack(
              children: [
                // 1. The Interactive Infinite Whiteboard Engine
                const Positioned.fill(
                  child: VectorCanvasWidget(),
                ),

                // 2. Glassmorphic App Bar (Top Header)
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: _buildGlassyHeader(context),
                ),

                // 3. Floating Premium Whitish Top Toolbar
                Positioned(
                  top: 96,
                  left: 0,
                  right: 0,
                  child: _buildWhitishTopToolbar(context),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildGlassyHeader(BuildContext context) {
    return Container(
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        border: Border(
          bottom: BorderSide(color: Colors.black.withOpacity(0.06)),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // A. Circular Back button
            IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF0F172A), size: 18),
              onPressed: () {
                context.read<VectorEditorBloc>().add(const SaveVectorNote());
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(width: 12),

            // B. Double-tap Editable note title
            Expanded(
              child: _isEditingTitle
                  ? TextField(
                      controller: _titleController,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF0F172A),
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                      autofocus: true,
                      onSubmitted: (val) {
                        setState(() {
                          _isEditingTitle = false;
                        });
                        // Triggers persistence saves on title updates
                        context.read<VectorEditorBloc>().add(const SaveVectorNote());
                      },
                    )
                  : GestureDetector(
                      onDoubleTap: () {
                        setState(() {
                          _isEditingTitle = true;
                        });
                      },
                      child: Text(
                        _titleController.text,
                        style: GoogleFonts.outfit(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
            ),

            // C. Sync Status & Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFEEF2FF),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.cloud_done_rounded, color: Color(0xFF6366F1), size: 14),
                  const SizedBox(width: 4),
                  Text(
                    'Local Sync',
                    style: GoogleFonts.outfit(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF6366F1),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhitishTopToolbar(BuildContext context) {
    return BlocBuilder<VectorEditorBloc, VectorEditorState>(
      builder: (context, state) {
        if (state is! VectorEditorLoaded) return const SizedBox.shrink();

        final activeTool = state.activeTool;

        return Center(
          child: Container(
            height: 52,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.black.withOpacity(0.08)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // A. Pan Navigation Tool
                _buildToolButton(
                  icon: Icons.pan_tool_rounded,
                  label: 'Pan Mode',
                  isActive: activeTool == VectorTool.pan,
                  onTap: () => context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.pan)),
                ),
                const SizedBox(width: 4),

                // B. Edit Workspace Tool
                _buildToolButton(
                  icon: Icons.ads_click_rounded,
                  label: 'Edit Mode',
                  isActive: activeTool == VectorTool.select,
                  onTap: () => context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.select)),
                ),
                const SizedBox(width: 4),

                // C. Ink Drawing Tool
                _buildToolButton(
                  icon: Icons.brush_rounded,
                  label: 'Ink',
                  isActive: activeTool == VectorTool.pen,
                  onTap: () => context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.pen)),
                ),
                const SizedBox(width: 4),

                // D. Stroke Eraser Tool
                _buildToolButton(
                  icon: Icons.auto_fix_high_rounded,
                  label: 'Eraser',
                  isActive: activeTool == VectorTool.eraser,
                  onTap: () => context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.eraser)),
                ),
                const SizedBox(width: 4),

                // E. Lasso Tool
                _buildToolButton(
                  icon: Icons.gesture_rounded,
                  label: 'Lasso',
                  isActive: activeTool == VectorTool.connector,
                  onTap: () => context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.connector)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildToolButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF8B5CF6).withOpacity(0.12) : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? const Color(0xFF8B5CF6) : Colors.black54,
            size: 20,
          ),
        ),
      ),
    );
  }

  Future<void> _pickAndAddPhoto(BuildContext context) async {
    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      if (context.mounted) {
        context.read<VectorEditorBloc>().add(
              AddPhotoNode(
                canvasPosition: const Offset(15000, 10000), // Spawns right in the center of our vast 30000x20000 canvas!
                filePath: path,
              ),
            );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Photo added to canvas!')),
        );
      }
    }
  }
}
