import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/services/text_layout_service.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import 'editor/rich_text_controller.dart';
import 'note_context_menu.dart';
import 'note_page_layers.dart';

/// The interactive note page widget.
///
/// Owns the text editing state (controller, focus, caret blink animation,
/// drag-selection anchor) and wires gesture events to the BLoC.
/// Visual rendering and the keyboard sink are delegated to [NotePageLayers].
/// Right-click menu is handled by [showNoteContextMenu].
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
  late AnimationController _caretBlinkController;
  late String _lastKnownText;

  bool _isCaretVisible    = true;
  bool _isProgrammaticUpdate = false;

  /// Anchor character offset for click-drag text selection.
  int? _dragAnchorOffset;

  // ── Lifecycle ──────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    final textBlock  = widget.page.blocks.whereType<TextBlock>().firstOrNull;
    _lastKnownText   = textBlock?.content.plainText ?? '';
    _textController  = RichNoteTextController(text: _lastKnownText);
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
      WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
    }
  }

  @override
  void dispose() {
    _caretBlinkController.dispose();
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // ── Controller listener ────────────────────────────────────────────────────

  /// Forwards selection changes from the TextField to the BLoC,
  /// but only when the change was triggered by the user (not programmatically)
  /// and only when the text itself has NOT changed (which would mean it's a
  /// typing event, handled separately by [UpdateNoteText]).
  void _onSelectionChanged() {
    if (_isProgrammaticUpdate) return;
    if (_textController.text != _lastKnownText) return; // typing — skip

    if (_focusNode.hasFocus) {
      context.read<NoteEditorBloc>().add(
        UpdateSelection(
          selection: _textController.selection,
          pageIndex: widget.pageIndex,
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NoteEditorBloc, NoteEditorState>(
      builder: (context, state) {
        if (state is! NoteEditorLoaded) return const SizedBox.shrink();

        final textBlock    = widget.page.blocks.whereType<TextBlock>().firstOrNull;
        final isPenMode    = state.activeTool == EditorTool.pen;
        final isEraserMode = state.activeTool == EditorTool.eraser;
        final selection    = state.selection;
        final activePageIdx = state.activePageIndex;

        // ── Sync controller with bloc state ──────────────────────────────────
        if (textBlock != null &&
            _textController.content != textBlock.content) {
          _textController.content = textBlock.content;
          _isProgrammaticUpdate   = true;
          _lastKnownText          = textBlock.content.plainText;
          _textController.value   = TextEditingValue(
            text:      _lastKnownText,
            selection: _textController.selection,
          );
          _isProgrammaticUpdate = false;
        }

        if (!isPenMode && activePageIdx == widget.pageIndex) {
          if (selection != null &&
              selection.isValid &&
              _textController.selection != selection) {
            _isProgrammaticUpdate = true;
            try { _textController.selection = selection; } catch (_) {}
            _isProgrammaticUpdate = false;
          }
          if (!_focusNode.hasFocus && _textController.text.isNotEmpty) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) _focusNode.requestFocus();
            });
          }
        }

        // ── Compute caret / selection rects ───────────────────────────────────
        final layoutService = TextLayoutService();
        CaretMetrics? caretMetrics;
        List<Rect>?   selectionRects;

        const defaultStyle = TextStyle(fontFamily: 'Roboto', fontSize: 16, height: 1.2);

        if (!isPenMode && selection != null && activePageIdx == widget.pageIndex && textBlock != null) {
          if (selection.isCollapsed) {
            caretMetrics = layoutService.getCaretMetrics(
              content:      textBlock.content,
              charOffset:   selection.extentOffset,
              maxWidth:     textBlock.size.width,
              defaultStyle: defaultStyle,
            );
          } else {
            selectionRects = layoutService.getSelectionRects(
              content:      textBlock.content,
              selection:    selection,
              maxWidth:     textBlock.size.width,
              defaultStyle: defaultStyle,
            );
          }
        }

        // ── Gesture + mouse layer ─────────────────────────────────────────────
        return Listener(
          onPointerDown: (event) {
            // Right-click → context menu (caret does NOT move)
            if (event.buttons == 2 && textBlock != null) {
              showNoteContextMenu(
                context:        context,
                globalPosition: event.position,
                textBlock:      textBlock,
                selection:      selection,
                pageIndex:      widget.pageIndex,
              );
              return;
            }

            // Text tap → map to char offset via OUR TextPainter (single source of truth)
            if (!isPenMode && !isEraserMode && textBlock != null) {
              final localTap  = event.localPosition - textBlock.position;
              final charOffset = layoutService.getPositionForOffset(
                content:          textBlock.content,
                localTapPosition: localTap,
                maxWidth:         textBlock.size.width,
                defaultStyle:     defaultStyle,
              );
              context.read<NoteEditorBloc>().add(UpdateSelection(
                selection: TextSelection.collapsed(offset: charOffset),
                pageIndex: widget.pageIndex,
              ));
              _dragAnchorOffset = charOffset;
              if (!_focusNode.hasFocus) _focusNode.requestFocus();
            }

            if (activePageIdx != widget.pageIndex && textBlock != null) {
              context.read<NoteEditorBloc>().add(UpdateSelection(
                selection: _textController.selection,
                pageIndex: widget.pageIndex,
              ));
            }

            if (isPenMode) {
              context.read<NoteEditorBloc>().add(StartStroke(
                position:  event.localPosition,
                pressure:  event.pressure,
                pageIndex: widget.pageIndex,
              ));
            }
            if (isEraserMode) {
              context.read<NoteEditorBloc>().add(EraseAtPosition(
                position:  event.localPosition,
                pageIndex: widget.pageIndex,
              ));
            }
          },

          onPointerMove: (event) {
            // Drag selection
            if (!isPenMode && !isEraserMode && textBlock != null && _dragAnchorOffset != null) {
              final localTap     = event.localPosition - textBlock.position;
              final currentOffset = layoutService.getPositionForOffset(
                content:          textBlock.content,
                localTapPosition: localTap,
                maxWidth:         textBlock.size.width,
                defaultStyle:     defaultStyle,
              );
              final start = _dragAnchorOffset! < currentOffset ? _dragAnchorOffset! : currentOffset;
              final end   = _dragAnchorOffset! < currentOffset ? currentOffset : _dragAnchorOffset!;
              context.read<NoteEditorBloc>().add(UpdateSelection(
                selection: TextSelection(baseOffset: start, extentOffset: end),
                pageIndex: widget.pageIndex,
              ));
            }
            if (isPenMode) {
              context.read<NoteEditorBloc>().add(UpdateStroke(
                position: event.localPosition,
                pressure: event.pressure,
              ));
            }
            if (isEraserMode) {
              context.read<NoteEditorBloc>().add(EraseAtPosition(
                position:  event.localPosition,
                pageIndex: widget.pageIndex,
              ));
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
              width:  widget.page.width,
              height: widget.page.height,
              color:  Colors.white,
              child: NotePageLayers(
                page:           widget.page,
                pageIndex:      widget.pageIndex,
                showGrid:       widget.showGrid,
                state:          state,
                caretMetrics:   caretMetrics,
                selectionRects: selectionRects,
                isCaretVisible: _isCaretVisible && _focusNode.hasFocus,
                textController: _textController,
                focusNode:      _focusNode,
              ),
            ),
          ),
        );
      },
    );
  }
}
