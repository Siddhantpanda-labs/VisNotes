import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/entities/text_content.dart';
import '../../domain/services/text_layout_service.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import 'note_page_widget.dart';
import 'page_painter.dart';

class EditableNotePage extends StatefulWidget {
  final NotePage page;
  final int pageIndex;
  final bool showGrid;

  const EditableNotePage({
    super.key,
    required this.page,
    required this.pageIndex,
    this.showGrid = true,
  });

  @override
  State<EditableNotePage> createState() => _EditableNotePageState();
}

class _EditableNotePageState extends State<EditableNotePage> with SingleTickerProviderStateMixin {
  late RichNoteTextController _textController;
  late FocusNode _focusNode;
  bool _isCaretVisible = true;
  late AnimationController _caretBlinkController;

  @override
  void initState() {
    super.initState();
    final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
    _textController = RichNoteTextController(text: textBlock?.content.plainText ?? '');
    _textController.content = textBlock?.content;
    _focusNode = FocusNode();

    _textController.addListener(_onSelectionChanged);

    _caretBlinkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() => _isCaretVisible = !_isCaretVisible);
          _caretBlinkController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _caretBlinkController.forward();
        }
      });
    _caretBlinkController.forward();

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
        final selection = currentState.selection;
        final pageIndex = currentState.activePageIndex;
        
        if (textBlock != null) {
          _textController.content = textBlock.content;
        }

        // Maintain focus if we are in select mode and this is the active page
        if (!isPenMode && pageIndex == widget.pageIndex) {
          if (!_focusNode.hasFocus && _textController.text.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _focusNode.requestFocus();
            });
          }
        }

        // Calculate custom caret metrics and selection rects
        CaretMetrics? caretMetrics;
        List<Rect>? selectionRects;
        
        if (!isPenMode && selection != null && pageIndex == widget.pageIndex) {
          final layoutService = TextLayoutService();
          final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
          if (textBlock != null) {
            if (selection.isCollapsed) {
              caretMetrics = layoutService.getCaretMetrics(
                content: textBlock.content,
                charOffset: selection.extentOffset,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, height: 1.2),
                activeAttributes: currentState.activeTypingAttributes,
              );
            } else {
              selectionRects = layoutService.getSelectionRects(
                content: textBlock.content,
                selection: selection,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, height: 1.2),
              );
            }
          }
        }

        return Listener(
          onPointerDown: (event) {
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(StartStroke(
                    position: event.localPosition,
                    pressure: event.pressure,
                    pageIndex: widget.pageIndex,
                  ));
            }
          },
          onPointerMove: (event) {
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(UpdateStroke(
                    position: event.localPosition,
                    pressure: event.pressure,
                  ));
            }
          },
          onPointerUp: (event) {
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(const EndStroke());
            }
          },
          child: Stack(
            children: [
              // Visual Layer
              CustomPaint(
                size: Size(widget.page.width, widget.page.height),
                painter: PagePainter(
                  page: widget.page,
                  selection: selection,
                  selectionRects: selectionRects,
                  caretOffset: caretMetrics?.offset,
                  caretHeight: caretMetrics?.height,
                  isCaretVisible: _isCaretVisible && _focusNode.hasFocus,
                  showGrid: widget.showGrid,
                ),
              ),

              // Active Ink Layer (Drawing currently)
              if (currentState.currentStroke != null && pageIndex == widget.pageIndex)
                IgnorePointer(
                  child: CustomPaint(
                    size: Size(widget.page.width, widget.page.height),
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

              // Text Input Layer
              if (textBlock != null)
                Positioned(
                  left: textBlock.position.dx,
                  top: textBlock.position.dy,
                  width: textBlock.size.width,
                  height: textBlock.size.height,
                  child: IgnorePointer(
                    ignoring: isPenMode, // Disable text interaction in pen mode
                    child: Builder(builder: (context) {
                      final activeAttr = currentState.activeTypingAttributes;
                      final fontSize = activeAttr.isHeading ? (activeAttr.fontSize ?? 24) : (activeAttr.fontSize ?? 16);
                      final fontWeight = activeAttr.isBold ? FontWeight.bold : FontWeight.normal;
                      final fontStyle = activeAttr.isItalic ? FontStyle.italic : FontStyle.normal;

                      return Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: const TextSelectionThemeData(
                            selectionColor: Colors.transparent,
                            selectionHandleColor: Colors.transparent,
                          ),
                        ),
                        child: TextField(
                          controller: _textController,
                          focusNode: _focusNode,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            isDense: true,
                          ),
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: fontSize,
                            fontWeight: fontWeight,
                            fontStyle: fontStyle,
                            color: Colors.transparent, // Invisible text
                            height: 1.2,
                            letterSpacing: 0.0,
                          ),
                          cursorColor: Colors.transparent, // HIDE NATIVE CURSOR
                          onChanged: (value) {
                            context.read<NoteEditorBloc>().add(UpdateNoteText(
                                  text: value,
                                  pageIndex: widget.pageIndex,
                                  blockId: textBlock.id,
                                ));
                          },
                        ),
                      );
                    }),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

class RichNoteTextController extends TextEditingController {
  RichNoteTextController({super.text});

  RichTextContent? content;

  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    if (content == null) {
      return super.buildTextSpan(context: context, style: style, withComposing: withComposing);
    }

    // Build the TextSpan matching our custom visual layout exactly
    return TextSpan(
      children: content!.segments.map((segment) {
        return TextSpan(
          text: segment.text,
          style: (style ?? const TextStyle()).copyWith(
            fontFamily: 'Roboto',
            fontWeight: segment.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: segment.isItalic ? FontStyle.italic : FontStyle.normal,
            fontSize: segment.isHeading ? (segment.fontSize ?? 24) : (segment.fontSize ?? 16),
            color: Colors.transparent, // keep it invisible
            letterSpacing: 0.0,
            height: 1.2,
          ),
        );
      }).toList(),
    );
  }
}
