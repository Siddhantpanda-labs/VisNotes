import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'editable_note_page.dart';
import 'note_page_widget.dart';
import '../../domain/entities/note_document.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';

class SpatialCanvas extends StatefulWidget {
  const SpatialCanvas({super.key});

  @override
  State<SpatialCanvas> createState() => _SpatialCanvasState();
}

class _SpatialCanvasState extends State<SpatialCanvas> {
  late TransformationController _transformationController;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    
    // Center the view on the first page
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _centerView();
    });
  }

  void _centerView() {
    if (!mounted) return;
    final size = MediaQuery.of(context).size;
    const double startX = 1000; // Middle of our 2000x2000 workspace
    const double startY = 200;
    
    // Offset the view so (startX, startY) is at screen center
    final double tx = size.width / 2 - startX;
    final double ty = size.height / 2 - startY;

    setState(() {
      _transformationController.value = Matrix4.identity()
        ..translate(tx, ty);
    });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      builder: (context, state) {
        if (state is NoteEditorLoaded) {
          final document = state.document;
          final isPenMode = state.activeTool == EditorTool.pen;
          
          return InteractiveViewer(
            transformationController: _transformationController,
            // Disable panning/zooming when drawing to prevent tool conflict
            panEnabled: !isPenMode,
            scaleEnabled: !isPenMode,
            boundaryMargin: const EdgeInsets.all(2000),
            minScale: 0.1,
            maxScale: 5.0,
            child: Stack(
              children: [
                const SizedBox(
                  width: 5000,
                  height: 5000,
                ),
                ..._buildPages(document),
              ],
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _buildPages(NoteDocument document) {
    const double startX = 1000.0;
    const double startY = 200.0;
    const double spacing = 40.0;

    double currentY = startY;

    return document.pages.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final page = entry.value;
      
      final widget = Positioned(
        left: startX - (page.width / 2),
        top: currentY,
        child: EditableNotePage(
          page: page,
          pageIndex: index,
        ),
      );

      currentY += page.height + spacing;
      return widget;
    }).toList();
  }
}
