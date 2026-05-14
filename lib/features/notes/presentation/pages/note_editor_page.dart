import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../data/repositories/note_repository.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/entities/text_content.dart';
import '../../domain/services/text_layout_service.dart';
import '../../domain/services/pagination_service.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import '../widgets/spatial_canvas.dart';
import '../widgets/formatting_toolbar.dart';

class NoteEditorPage extends StatelessWidget {
  final NoteDocument? initialDocument;

  const NoteEditorPage({super.key, this.initialDocument});

  @override
  Widget build(BuildContext context) {
    final layoutService = TextLayoutService();

    var doc = initialDocument ?? _createInitialDocument();
    if (doc.pages.isEmpty) {
      doc = doc.copyWith(pages: [_createInitialDocument().pages.first]);
    }
    
    return BlocProvider(
      create: (context) => NoteEditorBloc(
        layoutService: layoutService,
        paginationService: NotePaginationService(layoutService: layoutService),
        noteRepository: context.read<NoteRepository>(),
      )..add(LoadNoteDocument(doc)),
      child: Builder(
        builder: (context) {
          return PopScope(
            onPopInvokedWithResult: (didPop, result) {
              if (didPop) {
                // Trigger a final save before leaving
                context.read<NoteEditorBloc>().add(const SaveNote());
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: Text(initialDocument?.title ?? 'VisNotes'),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black87,
                    size: 20,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(
                      Icons.center_focus_strong,
                      color: Colors.black87,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
              body: Stack(
                children: [
                  const SpatialCanvas(),

                  // Formatting Toolbar
                  Positioned(
                    bottom: 40,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: BlocBuilder<NoteEditorBloc, NoteEditorState>(
                        builder: (context, state) {
                          if (state is! NoteEditorLoaded)
                            return const SizedBox.shrink();
                          return FormattingToolbar(
                            activeTool: state.activeTool,
                            isBold: state.activeTypingAttributes.isBold,
                            isItalic: state.activeTypingAttributes.isItalic,
                            isHeading: state.activeTypingAttributes.isHeading,
                            onToolChanged: (tool) {
                              context.read<NoteEditorBloc>().add(
                                ChangeTool(tool),
                              );
                            },
                            onBoldToggle: () {
                              context.read<NoteEditorBloc>().add(
                                const ToggleFormat(isBold: true),
                              );
                            },
                            onItalicToggle: () {
                              context.read<NoteEditorBloc>().add(
                                const ToggleFormat(isItalic: true),
                              );
                            },
                            onHeadingToggle: () {
                              context.read<NoteEditorBloc>().add(
                                const ToggleFormat(isHeading: true),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  NoteDocument _createInitialDocument() {
    const uuid = Uuid();
    return NoteDocument(
      id: uuid.v4(),
      title: 'New Note',
      pages: [
        NotePage(
          id: uuid.v4(),
          width: 792.0,
          height: 1056.0,
          blocks: [
            TextBlock(
              id: uuid.v4(),
              position: const Offset(40, 40),
              size: const Size(712, 1016),
              content: const RichTextContent(segments: [TextSegment(text: '')]),
            ),
          ],
        ),
      ],
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
