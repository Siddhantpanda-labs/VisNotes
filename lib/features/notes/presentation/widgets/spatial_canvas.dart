import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'editable_note_page.dart';
import '../../domain/entities/note_document.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';

class SpatialCanvas extends StatefulWidget {
  const SpatialCanvas({super.key});

  @override
  State<SpatialCanvas> createState() => _SpatialCanvasState();
}

class _SpatialCanvasState extends State<SpatialCanvas> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      builder: (context, state) {
        if (state is NoteEditorLoaded) {
          final document = state.document;
          
          return Container(
            color: const Color(0xFFF5F5F7), // Apple/Premium Studio Background
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
              child: Center(
                child: Column(
                  children: _buildPages(document),
                ),
              ),
            ),
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  List<Widget> _buildPages(NoteDocument document) {
    const double spacing = 32.0;

    return document.pages.asMap().entries.map<Widget>((entry) {
      final index = entry.key;
      final page = entry.value;
      
      return Padding(
        padding: EdgeInsets.only(bottom: index == document.pages.length - 1 ? 0 : spacing),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: EditableNotePage(
            page: page,
            pageIndex: index,
            showGrid: true, // Keep the pro grid
          ),
        ),
      );
    }).toList();
  }
}
