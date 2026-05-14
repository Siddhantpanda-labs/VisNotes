import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/services/text_layout_service.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import 'page_painter.dart';
import 'editor/rich_text_controller.dart';
import 'editor/caret_tracker.dart';

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

class _EditableNotePageState extends State<EditableNotePage>
    with SingleTickerProviderStateMixin {
  late RichNoteTextController _textController;
  late FocusNode _focusNode;
  bool _isCaretVisible = true;
  late AnimationController _caretBlinkController;
  late String _lastKnownText;

  // Used for click-drag text selection
  int? _dragAnchorOffset;

  @override
  void initState() {
    super.initState();
    final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
    _lastKnownText = textBlock?.content.plainText ?? '';
    _textController = RichNoteTextController(
      text: _lastKnownText,
    );
    _textController.content = textBlock?.content;
    _focusNode = FocusNode();

    _textController.addListener(_onSelectionChanged);

    _caretBlinkController =
        AnimationController(
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

  bool _isProgrammaticUpdate = false;

  @override
  void didUpdateWidget(EditableNotePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.page != oldWidget.page) {
      final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
      if (textBlock != null &&
          textBlock.content.plainText != _textController.text) {
        _isProgrammaticUpdate = true;
        _lastKnownText = textBlock.content.plainText;
        
        // Save current selection before updating text to prevent cursor jumps
        final currentSelection = _textController.selection;
        _textController.text = _lastKnownText;
        _textController.content = textBlock.content;

        // Restore selection safely
        if (currentSelection.isValid &&
            currentSelection.extentOffset <= _textController.text.length) {
          _textController.selection = currentSelection;
        } else {
          _textController.selection = TextSelection.collapsed(
            offset: _textController.text.length,
          );
        }
        _isProgrammaticUpdate = false;
      }
    }
  }

  void _onSelectionChanged() {
    if (_isProgrammaticUpdate) return;
    
    // Crucial: Prevent "caret moved" events from firing while the text is actively 
    // changing. If text changed, it's a typing event, not a manual caret move!
    if (_textController.text != _lastKnownText) return;

    if (_focusNode.hasFocus) {
      context.read<NoteEditorBloc>().add(
        UpdateSelection(
          selection: _textController.selection,
          pageIndex: widget.pageIndex,
        ),
      );
    }
  }

  @override
  void dispose() {
    _caretBlinkController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Future<void> _showContextMenu({
    required BuildContext context,
    required Offset globalPosition,
    required TextBlock textBlock,
    required TextSelection? selection,
    required int pageIndex,
  }) async {
    final bloc = context.read<NoteEditorBloc>();
    final hasSelection = selection != null && !selection.isCollapsed;
    final text = textBlock.content.plainText;

    // Build menu entries: [value, label, isDivider]
    final entries = <(String, String)>[];
    entries.add(('select_all', 'Select All'));
    if (hasSelection) {
      entries.add(('cut', 'Cut'));
      entries.add(('copy', 'Copy'));
    }
    entries.add(('paste', 'Paste'));

    const bg = Color(0xFF2C2C2E);
    const fg = Color(0xFFEEEEEE);
    const divColor = Color(0xFF3A3A3C);
    const itemH = 30.0;

    final result = await showDialog<String>(
      context: context,
      barrierColor: Colors.transparent,
      barrierDismissible: true,
      builder: (dialogCtx) => Stack(
        children: [
          Positioned(
            left: globalPosition.dx,
            top: globalPosition.dy,
            child: Material(
              color: Colors.transparent,
              child: Container(
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(7),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 3)),
                  ],
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (int i = 0; i < entries.length; i++) ...[
                        if (i == 1 && hasSelection)
                          const Divider(height: 1, thickness: 1, color: divColor),
                        if (i == (hasSelection ? 3 : 1))
                          const Divider(height: 1, thickness: 1, color: divColor),
                        InkWell(
                          onTap: () => Navigator.of(dialogCtx, rootNavigator: true)
                              .pop(entries[i].$1),
                          borderRadius: BorderRadius.vertical(
                            top: i == 0 ? const Radius.circular(7) : Radius.zero,
                            bottom: i == entries.length - 1
                                ? const Radius.circular(7)
                                : Radius.zero,
                          ),
                          highlightColor: Colors.white10,
                          splashColor: Colors.white10,
                          child: SizedBox(
                            height: itemH,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 14),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  entries[i].$2,
                                  style: const TextStyle(
                                    fontSize: 12.5,
                                    color: fg,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.w400,
                                    letterSpacing: 0.1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (result == null || !mounted) return;

    switch (result) {
      case 'select_all':
        bloc.add(UpdateSelection(
          selection: TextSelection(baseOffset: 0, extentOffset: text.length),
          pageIndex: pageIndex,
        ));

      case 'copy':
        if (hasSelection) {
          await Clipboard.setData(
            ClipboardData(text: text.substring(selection!.start, selection.end)),
          );
        }

      case 'cut':
        if (hasSelection) {
          await Clipboard.setData(
            ClipboardData(text: text.substring(selection!.start, selection.end)),
          );
          if (!mounted) return;
          final newText = text.substring(0, selection.start) + text.substring(selection.end);
          bloc.add(UpdateNoteText(
            text: newText,
            pageIndex: pageIndex,
            blockId: textBlock.id,
            selection: TextSelection.collapsed(offset: selection.start),
          ));
        }

      case 'paste':
        final data = await Clipboard.getData(Clipboard.kTextPlain);
        if (!mounted || data?.text == null) return;
        final pasteText = data!.text!;
        final insertAt  = hasSelection ? selection!.start : (selection?.extentOffset ?? text.length);
        final deleteEnd = hasSelection ? selection!.end   : insertAt;
        final newText = text.substring(0, insertAt) + pasteText + text.substring(deleteEnd);
        bloc.add(UpdateNoteText(
          text: newText,
          pageIndex: pageIndex,
          blockId: textBlock.id,
          selection: TextSelection.collapsed(offset: insertAt + pasteText.length),
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      builder: (context, state) {
        if (state is! NoteEditorLoaded) return const SizedBox.shrink();
        final currentState = state;
        final textBlock = widget.page.blocks.whereType<TextBlock>().firstOrNull;
        final isPenMode = currentState.activeTool == EditorTool.pen;
        final isEraserMode = currentState.activeTool == EditorTool.eraser;
        final selection = currentState.selection;
        final pageIndex = currentState.activePageIndex;

        if (textBlock != null) {
          if (_textController.content != textBlock.content) {
            _textController.content = textBlock.content;

            _isProgrammaticUpdate = true;
            _textController.value = TextEditingValue(
              text: textBlock.content.plainText,
              selection: _textController.selection,
            );
            _isProgrammaticUpdate = false;
          }
        }

        if (!isPenMode && pageIndex == widget.pageIndex) {
          if (selection != null &&
              selection.isValid &&
              _textController.selection != selection) {
            _isProgrammaticUpdate = true;
            try {
              _textController.selection = selection;
            } catch (_) {}
            _isProgrammaticUpdate = false;
          }
          if (!_focusNode.hasFocus && _textController.text.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _focusNode.requestFocus();
            });
          }
        }

        final layoutService = TextLayoutService();
        CaretMetrics? caretMetrics;
        List<Rect>? selectionRects;

        if (!isPenMode && selection != null && pageIndex == widget.pageIndex) {
          if (textBlock != null) {
            if (selection.isCollapsed) {
              caretMetrics = layoutService.getCaretMetrics(
                content: textBlock.content,
                charOffset: selection.extentOffset,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  height: 1.2,
                ),
              );
            } else {
              selectionRects = layoutService.getSelectionRects(
                content: textBlock.content,
                selection: selection,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  height: 1.2,
                ),
              );
            }
          }
        }

        return Listener(
          onPointerDown: (event) {
            // Right-click → context menu (don't move caret)
            if (event.buttons == 2 /* kSecondaryMouseButton */ && textBlock != null) {
              _showContextMenu(
                context: context,
                globalPosition: event.position,
                textBlock: textBlock,
                selection: selection,
                pageIndex: widget.pageIndex,
              );
              return;
            }

            // --- TEXT TAP: Map tap → charOffset using OUR TextPainter ---
            // This is the single source of truth. The invisible TextField never
            // handles pointer events; our layout service maps taps directly.
            if (!isPenMode && !isEraserMode && textBlock != null) {
              final localTap = event.localPosition -
                  Offset(textBlock.position.dx, textBlock.position.dy);
              final charOffset = layoutService.getPositionForOffset(
                content: textBlock.content,
                localTapPosition: localTap,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  height: 1.2,
                ),
              );
              context.read<NoteEditorBloc>().add(
                UpdateSelection(
                  selection: TextSelection.collapsed(offset: charOffset),
                  pageIndex: widget.pageIndex,
                ),
              );
              _dragAnchorOffset = charOffset; // anchor for drag selection
              if (!_focusNode.hasFocus) _focusNode.requestFocus();
            }

            if (pageIndex != widget.pageIndex && textBlock != null) {
              context.read<NoteEditorBloc>().add(
                UpdateSelection(
                  selection: _textController.selection,
                  pageIndex: widget.pageIndex,
                ),
              );
            }

            if (isPenMode) {
              context.read<NoteEditorBloc>().add(
                StartStroke(
                  position: event.localPosition,
                  pressure: event.pressure,
                  pageIndex: widget.pageIndex,
                ),
              );
            }
            if (isEraserMode) {
              context.read<NoteEditorBloc>().add(
                EraseAtPosition(
                  position: event.localPosition,
                  pageIndex: widget.pageIndex,
                ),
              );
            }
          },
          onPointerMove: (event) {
            // --- TEXT DRAG SELECTION ---
            if (!isPenMode && !isEraserMode && textBlock != null && _dragAnchorOffset != null) {
              final localTap = event.localPosition -
                  Offset(textBlock.position.dx, textBlock.position.dy);
              final currentOffset = layoutService.getPositionForOffset(
                content: textBlock.content,
                localTapPosition: localTap,
                maxWidth: textBlock.size.width,
                defaultStyle: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  height: 1.2,
                ),
              );
              // Build the range from anchor to current (handles both left and right drag)
              final start = _dragAnchorOffset! < currentOffset ? _dragAnchorOffset! : currentOffset;
              final end   = _dragAnchorOffset! < currentOffset ? currentOffset : _dragAnchorOffset!;
              context.read<NoteEditorBloc>().add(
                UpdateSelection(
                  selection: TextSelection(baseOffset: start, extentOffset: end),
                  pageIndex: widget.pageIndex,
                ),
              );
            }
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(
                UpdateStroke(
                  position: event.localPosition,
                  pressure: event.pressure,
                ),
              );
            }
            if (isEraserMode) {
              context.read<NoteEditorBloc>().add(
                EraseAtPosition(
                  position: event.localPosition,
                  pageIndex: widget.pageIndex,
                ),
              );
            }
          },
          onPointerUp: (event) {
            _dragAnchorOffset = null;
            if (isPenMode || isEraserMode) {
              context.read<NoteEditorBloc>().add(const EndStroke());
            }
          },
          onPointerCancel: (event) {
            _dragAnchorOffset = null;
            if (isPenMode || isEraserMode) {
              context.read<NoteEditorBloc>().add(const EndStroke());
            }
          },
          child: MouseRegion(
            cursor: (isPenMode || isEraserMode)
                ? SystemMouseCursors.precise
                : SystemMouseCursors.text,
            child: Container(
              width: widget.page.width,
              height: widget.page.height,
              color: Colors.white,
              child: Stack(
              children: [
                ClipRect(
                  child: CustomPaint(
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
                ),

                if (currentState.currentStroke != null &&
                    pageIndex == widget.pageIndex)
                  IgnorePointer(
                    child: ClipRect(
                      child: CustomPaint(
                        size: Size(widget.page.width, widget.page.height),
                        painter: PagePainter(
                          page: NotePage(
                            id: 'active',
                            blocks: [
                              CanvasBlock(
                                id: 'active_canvas',
                                position: Offset.zero,
                                size: Size(
                                  widget.page.width,
                                  widget.page.height,
                                ),
                                strokes: [currentState.currentStroke!],
                              ),
                            ],
                            width: widget.page.width,
                            height: widget.page.height,
                          ),
                          showGrid: false,
                          drawBackground: false,
                        ),
                      ),
                    ),
                  ),

                if (isEraserMode &&
                    currentState.eraserPosition != null &&
                    pageIndex == widget.pageIndex)
                  Positioned(
                    left: currentState.eraserPosition!.dx - 25,
                    top: currentState.eraserPosition!.dy - 25,
                    child: IgnorePointer(
                      child: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.blue.withOpacity(0.5),
                            width: 2,
                          ),
                          color: Colors.blue.withOpacity(0.1),
                        ),
                      ),
                    ),
                  ),

                if (textBlock != null)
                  Positioned(
                    left: textBlock.position.dx,
                    top: textBlock.position.dy,
                    width: textBlock.size.width,
                    // No height constraint: let the TextField size to its content.
                    // TextLayoutService and PagePainter also lay out unconstrained in height.
                    // Keeping a tight height here caused RenderEditable to clamp tap Y coords,
                    // mapping clicks at the bottom of the page to wrong (upper) character offsets.
                    child: IgnorePointer(
                      // Always ignore pointer events — the TextField is a keyboard-only sink.
                      // All tap-to-offset mapping is handled by our Listener + TextLayoutService.
                      ignoring: true,
                      child: Builder(
                        builder: (context) {
                          final activeAttr =
                              currentState.activeTypingAttributes;
                          final fontSize = activeAttr.isHeading
                              ? (activeAttr.fontSize ?? 24)
                              : (activeAttr.fontSize ?? 16);
                          final fontWeight = activeAttr.isBold
                              ? FontWeight.bold
                              : FontWeight.normal;
                          final fontStyle = activeAttr.isItalic
                              ? FontStyle.italic
                              : FontStyle.normal;

                          return Theme(
                            data: Theme.of(context).copyWith(
                              textSelectionTheme: const TextSelectionThemeData(
                                selectionColor: Colors.transparent,
                                selectionHandleColor: Colors.transparent,
                              ),
                            ),
                            child: Focus(
                              onKey: (node, event) {
                                if (event is RawKeyDownEvent) {
                                  final text = _textController.text;
                                  final offset =
                                      _textController.selection.extentOffset;
                                  final state = context
                                      .read<NoteEditorBloc>()
                                      .state;

                                  if (state is NoteEditorLoaded) {
                                    if (event.logicalKey ==
                                            LogicalKeyboardKey.backspace &&
                                        offset == 0 &&
                                        widget.pageIndex > 0) {
                                      final prevPageIdx = widget.pageIndex - 1;
                                      final prevPage =
                                          state.document.pages[prevPageIdx];
                                      final prevBlock = prevPage.blocks
                                          .whereType<TextBlock>()
                                          .firstOrNull;

                                      context.read<NoteEditorBloc>().add(
                                        UpdateNoteText(
                                          text:
                                              (prevBlock?.content.plainText ??
                                                  '') +
                                              text,
                                          pageIndex: prevPageIdx,
                                          blockId: prevBlock?.id ?? '',
                                        ),
                                      );

                                      context.read<NoteEditorBloc>().add(
                                        UpdateSelection(
                                          selection: TextSelection.collapsed(
                                            offset:
                                                prevBlock
                                                    ?.content
                                                    .plainText
                                                    .length ??
                                                0,
                                          ),
                                          pageIndex: prevPageIdx,
                                        ),
                                      );

                                      context.read<NoteEditorBloc>().add(
                                        UpdateNoteText(
                                          text: '',
                                          pageIndex: widget.pageIndex,
                                          blockId: textBlock.id,
                                        ),
                                      );

                                      return KeyEventResult.handled;
                                    }

                                    if (event.logicalKey ==
                                            LogicalKeyboardKey.arrowRight &&
                                        offset == text.length &&
                                        widget.pageIndex <
                                            state.document.pages.length - 1) {
                                      context.read<NoteEditorBloc>().add(
                                        UpdateSelection(
                                          selection:
                                              const TextSelection.collapsed(
                                                offset: 0,
                                              ),
                                          pageIndex: widget.pageIndex + 1,
                                        ),
                                      );
                                      return KeyEventResult.handled;
                                    }

                                    if ((event.logicalKey ==
                                                LogicalKeyboardKey.arrowLeft ||
                                            event.logicalKey ==
                                                LogicalKeyboardKey.arrowUp) &&
                                        offset == 0 &&
                                        widget.pageIndex > 0) {
                                      final prevPageIdx = widget.pageIndex - 1;
                                      final prevPage =
                                          state.document.pages[prevPageIdx];
                                      final prevBlock = prevPage.blocks
                                          .whereType<TextBlock>()
                                          .firstOrNull;
                                      context.read<NoteEditorBloc>().add(
                                        UpdateSelection(
                                          selection: TextSelection.collapsed(
                                            offset:
                                                prevBlock
                                                    ?.content
                                                    .plainText
                                                    .length ??
                                                0,
                                          ),
                                          pageIndex: prevPageIdx,
                                        ),
                                      );
                                      return KeyEventResult.handled;
                                    }
                                  }
                                }
                                return KeyEventResult.ignored;
                              },
                              child: TextField(
                                controller: _textController,
                                focusNode: _focusNode,
                                maxLines: null,
                                scrollPhysics:
                                    const NeverScrollableScrollPhysics(),
                                decoration: const InputDecoration(
                                  isCollapsed: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.zero,
                                  isDense: true,
                                ),
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: fontSize,
                                  fontWeight: fontWeight,
                                  fontStyle: fontStyle,
                                  color: Colors.transparent,
                                  height: 1.2,
                                  letterSpacing: 0.0,
                                ),
                                strutStyle: const StrutStyle(
                                  fontFamily: 'Roboto',
                                  fontSize: 16,
                                  height: 1.2,
                                  forceStrutHeight: false,
                                ),
                                cursorColor: Colors.transparent,
                                onChanged: (value) {
                                  _lastKnownText = value;
                                  context.read<NoteEditorBloc>().add(
                                    UpdateNoteText(
                                      text: value,
                                      pageIndex: widget.pageIndex,
                                      blockId: textBlock.id,
                                      selection: _textController.selection,
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                if (caretMetrics != null)
                  Positioned(
                    left: textBlock!.position.dx + caretMetrics.offset.dx,
                    top: textBlock.position.dy + caretMetrics.offset.dy,
                    child: const CaretTracker(),
                  ),
              ],
            ),
          ), // Container
        ), // MouseRegion
      );
    },
  );
  }
}
