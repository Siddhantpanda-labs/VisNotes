import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/entities/stroke.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import 'note_page_widget.dart';
import 'page_painter.dart';

class EditableNotePage extends StatefulWidget {
  final NotePage page;
  final int pageIndex;

  const EditableNotePage({
    super.key,
    required this.page,
    required this.pageIndex,
  });

  @override
  State<EditableNotePage> createState() => _EditableNotePageState();
}

class _EditableNotePageState extends State<EditableNotePage> {
  late TextEditingController _textController;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
    _textController = TextEditingController(text: textBlock?.content.plainText ?? '');
    _focusNode = FocusNode();

    _textController.addListener(_onSelectionChanged);

    if (widget.pageIndex == 0) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  void _onSelectionChanged() {
    if (_focusNode.hasFocus) {
      context.read<NoteEditorBloc>().add(UpdateSelection(
            selection: _textController.selection,
            pageIndex: widget.pageIndex,
          ));
    }
  }

  @override
  void didUpdateWidget(EditableNotePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
    if (textBlock != null && textBlock.content.plainText != _textController.text) {
      final oldSelection = _textController.selection;
      _textController.text = textBlock.content.plainText;
      try {
        _textController.selection = oldSelection;
      } catch (_) {}
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      builder: (context, state) {
        if (state is! NoteEditorLoaded) return const SizedBox.shrink();
        final currentState = state;
        final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
        final isPenMode = currentState.activeTool == EditorTool.pen;

        // Maintain focus if we are in select mode and this is the active page
        if (!isPenMode && currentState.activePageIndex == widget.pageIndex) {
           if (!_focusNode.hasFocus && _textController.text.isNotEmpty) {
             WidgetsBinding.instance.addPostFrameCallback((_) {
               if (mounted) _focusNode.requestFocus();
             });
           }
        }

        return Listener(
          onPointerDown: (event) {
            if (isPenMode) {
              final localPos = _getLocalPosition(context, event.position);
              context.read<NoteEditorBloc>().add(StartStroke(
                position: localPos,
                pressure: event.pressure,
                pageIndex: widget.pageIndex,
              ));
            }
          },
          onPointerMove: (event) {
            if (isPenMode) {
              final localPos = _getLocalPosition(context, event.position);
              context.read<NoteEditorBloc>().add(UpdateStroke(
                position: localPos,
                pressure: event.pressure,
              ));
            }
          },
          onPointerUp: (event) {
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(const EndStroke());
            }
          },
          child: SizedBox(
            width: widget.page.width,
            height: widget.page.height,
            child: Stack(
              children: [
                NotePageWidget(page: widget.page),
                
                // Active stroke overlay
                if (currentState.activePageIndex == widget.pageIndex && currentState.currentStroke != null)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: PagePainter(
                          page: NotePage(
                            id: 'active',
                            blocks: [
                              CanvasBlock(
                                id: 'active_canvas',
                                position: Offset.zero,
                                size: Size(widget.page.width, widget.page.height),
                                strokes: [currentState.currentStroke!],
                              )
                            ],
                            width: widget.page.width,
                            height: widget.page.height,
                          ),
                          showGrid: false,
                        ),
                      ),
                    ),
                  ),

                // Text Input Layer
                if (textBlock != null)
                  Positioned(
                    left: textBlock.position.dx,
                    top: textBlock.position.dy,
                    width: textBlock.size.width,
                    height: textBlock.size.height,
                    child: IgnorePointer(
                      ignoring: isPenMode, // Disable text interaction in pen mode
                      child: TextField(
                        controller: _textController,
                        focusNode: _focusNode,
                        maxLines: null,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          isDense: true, // Reduces internal padding
                        ),
                        style: const TextStyle(
                          fontFamily: 'Roboto', // Explicitly lock font
                          fontSize: 16, 
                          color: Colors.transparent,
                          height: 1.2,
                          letterSpacing: 0.0,
                        ),
                        cursorColor: Colors.black,
                        onChanged: (value) {
                          context.read<NoteEditorBloc>().add(UpdateNoteText(
                                text: value,
                                pageIndex: widget.pageIndex,
                                blockId: textBlock.id,
                              ));
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Offset _getLocalPosition(BuildContext context, Offset globalPosition) {
    final RenderBox box = context.findRenderObject() as RenderBox;
    return box.globalToLocal(globalPosition);
  }
}
