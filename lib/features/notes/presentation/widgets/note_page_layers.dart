import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/entities/text_content.dart';
import '../../domain/services/text_layout_service.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';
import 'page_painter.dart';
import 'editor/rich_text_controller.dart';
import 'editor/caret_tracker.dart';

/// The visual and interactive layer stack for a single note page.
///
/// Responsibilities:
///   1. Visual layer  — [PagePainter] renders text, ink, selection highlights, caret.
///   2. Active ink    — a second [PagePainter] renders the in-progress stroke on top.
///   3. Eraser dot    — a translucent circle follows the eraser cursor.
///   4. Keyboard sink — an invisible, always-pointer-ignoring [TextField] captures
///                      keyboard input and cross-page navigation keystrokes.
///   5. Caret tracker — a [CaretTracker] widget triggers auto-scroll when the
///                      caret moves near the edge of the scroll view.
class NotePageLayers extends StatelessWidget {
  final NotePage page;
  final int pageIndex;
  final bool showGrid;
  final NoteEditorLoaded state;
  final CaretMetrics? caretMetrics;
  final List<Rect>? selectionRects;
  final bool isCaretVisible;
  final RichNoteTextController textController;
  final FocusNode focusNode;

  const NotePageLayers({
    super.key,
    required this.page,
    required this.pageIndex,
    required this.showGrid,
    required this.state,
    required this.caretMetrics,
    required this.selectionRects,
    required this.isCaretVisible,
    required this.textController,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final textBlock     = page.blocks.whereType<TextBlock>().firstOrNull;
    final selection     = state.selection;
    final currentStroke = state.currentStroke;
    final eraserPos     = state.eraserPosition;
    final activePageIdx = state.activePageIndex;
    final isEraserMode  = state.activeTool == EditorTool.eraser;
    final activeAttr    = state.activeTypingAttributes;

    return Stack(
      children: [
        // ── 1. Visual layer ──────────────────────────────────────────────────
        ClipRect(
          child: CustomPaint(
            size: Size(page.width, page.height),
            painter: PagePainter(
              page: page,
              selection: selection,
              selectionRects: selectionRects,
              caretOffset: caretMetrics?.offset,
              caretHeight: caretMetrics?.height,
              isCaretVisible: isCaretVisible,
              showGrid: showGrid,
            ),
          ),
        ),

        // ── 2. Active (in-progress) ink stroke ───────────────────────────────
        if (currentStroke != null && activePageIdx == pageIndex)
          IgnorePointer(
            child: ClipRect(
              child: CustomPaint(
                size: Size(page.width, page.height),
                painter: PagePainter(
                  page: NotePage(
                    id: 'active',
                    blocks: [
                      CanvasBlock(
                        id: 'active_canvas',
                        position: Offset.zero,
                        size: Size(page.width, page.height),
                        strokes: [currentStroke],
                      ),
                    ],
                    width: page.width,
                    height: page.height,
                  ),
                  showGrid: false,
                  drawBackground: false,
                ),
              ),
            ),
          ),

        // ── 3. Eraser cursor dot ─────────────────────────────────────────────
        if (isEraserMode && eraserPos != null && activePageIdx == pageIndex)
          Positioned(
            left: eraserPos.dx - 25,
            top:  eraserPos.dy - 25,
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

        // ── 4. Invisible keyboard-sink TextField ─────────────────────────────
        if (textBlock != null)
          Positioned(
            left:  textBlock.position.dx,
            top:   textBlock.position.dy,
            width: textBlock.size.width,
            // No height constraint — must match TextLayoutService (unconstrained).
            // A tight height causes RenderEditable to clamp tap-Y coords,
            // returning wrong character offsets for text near the bottom.
            child: IgnorePointer(
              // Always true — tap-to-offset is handled by the parent Listener.
              // This TextField is purely a keyboard-input sink.
              ignoring: true,
              child: _KeyboardSinkTextField(
                textBlock: textBlock,
                pageIndex: pageIndex,
                controller: textController,
                focusNode: focusNode,
                activeAttr: activeAttr,
                totalPages: state.document.pages.length,
                pages: state.document.pages,
              ),
            ),
          ),

        // ── 5. Caret tracker (auto-scroll) ───────────────────────────────────
        if (caretMetrics != null && textBlock != null)
          Positioned(
            left: textBlock.position.dx + caretMetrics!.offset.dx,
            top:  textBlock.position.dy + caretMetrics!.offset.dy,
            child: const CaretTracker(),
          ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Private widget: the invisible keyboard sink
// Extracted to keep NotePageLayers.build() readable.
// ---------------------------------------------------------------------------
class _KeyboardSinkTextField extends StatelessWidget {
  final TextBlock textBlock;
  final int pageIndex;
  final RichNoteTextController controller;
  final FocusNode focusNode;
  final TextSegment activeAttr;
  final int totalPages;
  final List<NotePage> pages;

  const _KeyboardSinkTextField({
    required this.textBlock,
    required this.pageIndex,
    required this.controller,
    required this.focusNode,
    required this.activeAttr,
    required this.totalPages,
    required this.pages,
  });

  @override
  Widget build(BuildContext context) {
    final fontSize   = activeAttr.isHeading ? (activeAttr.fontSize ?? 24) : (activeAttr.fontSize ?? 16);
    final fontWeight = activeAttr.isBold   ? FontWeight.bold   : FontWeight.normal;
    final fontStyle  = activeAttr.isItalic ? FontStyle.italic  : FontStyle.normal;

    return Theme(
      data: Theme.of(context).copyWith(
        textSelectionTheme: const TextSelectionThemeData(
          selectionColor:       Colors.transparent,
          selectionHandleColor: Colors.transparent,
        ),
      ),
      child: Focus(
        onKey: (node, event) => _handleKey(context, event),
        child: TextField(
          controller:    controller,
          focusNode:     focusNode,
          maxLines:      null,
          scrollPhysics: const NeverScrollableScrollPhysics(),
          decoration: const InputDecoration(
            isCollapsed:    true,
            border:         InputBorder.none,
            contentPadding: EdgeInsets.zero,
            isDense:        true,
          ),
          style: TextStyle(
            fontFamily:    'Roboto',
            fontSize:      fontSize,
            fontWeight:    fontWeight,
            fontStyle:     fontStyle,
            color:         Colors.transparent,
            height:        1.2,
            letterSpacing: 0.0,
          ),
          strutStyle: const StrutStyle(
            fontFamily:        'Roboto',
            fontSize:          16,
            height:            1.2,
            forceStrutHeight:  false,
          ),
          cursorColor: Colors.transparent,
          onChanged: (value) {
            context.read<NoteEditorBloc>().add(
              UpdateNoteText(
                text:      value,
                pageIndex: pageIndex,
                blockId:   textBlock.id,
                selection: controller.selection,
              ),
            );
          },
        ),
      ),
    );
  }

  /// Handles cross-page keyboard navigation (backspace at start, arrows at edges).
  KeyEventResult _handleKey(BuildContext context, RawKeyEvent event) {
    if (event is! RawKeyDownEvent) return KeyEventResult.ignored;

    final text   = controller.text;
    final offset = controller.selection.extentOffset;
    final state  = context.read<NoteEditorBloc>().state;
    if (state is! NoteEditorLoaded) return KeyEventResult.ignored;

    // Backspace at offset 0 → merge with previous page
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        offset == 0 &&
        pageIndex > 0) {
      final prevIdx   = pageIndex - 1;
      final prevBlock = pages[prevIdx].blocks.whereType<TextBlock>().firstOrNull;
      final prevLen   = prevBlock?.content.plainText.length ?? 0;

      context.read<NoteEditorBloc>()
        ..add(UpdateNoteText(
          text:      (prevBlock?.content.plainText ?? '') + text,
          pageIndex: prevIdx,
          blockId:   prevBlock?.id ?? '',
        ))
        ..add(UpdateSelection(
          selection: TextSelection.collapsed(offset: prevLen),
          pageIndex: prevIdx,
        ))
        ..add(UpdateNoteText(
          text:      '',
          pageIndex: pageIndex,
          blockId:   textBlock.id,
        ));
      return KeyEventResult.handled;
    }

    // Arrow-right at end → move to next page
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        offset == text.length &&
        pageIndex < totalPages - 1) {
      context.read<NoteEditorBloc>().add(UpdateSelection(
        selection: const TextSelection.collapsed(offset: 0),
        pageIndex: pageIndex + 1,
      ));
      return KeyEventResult.handled;
    }

    // Arrow-left / Arrow-up at start → move to previous page
    if ((event.logicalKey == LogicalKeyboardKey.arrowLeft ||
         event.logicalKey == LogicalKeyboardKey.arrowUp) &&
        offset == 0 &&
        pageIndex > 0) {
      final prevIdx   = pageIndex - 1;
      final prevBlock = pages[prevIdx].blocks.whereType<TextBlock>().firstOrNull;
      context.read<NoteEditorBloc>().add(UpdateSelection(
        selection: TextSelection.collapsed(
          offset: prevBlock?.content.plainText.length ?? 0,
        ),
        pageIndex: prevIdx,
      ));
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }
}
