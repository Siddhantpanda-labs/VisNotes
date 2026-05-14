import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/note_block.dart';
import '../../../domain/entities/note_document.dart';
import '../../../domain/entities/stroke.dart';
import '../../../domain/entities/text_content.dart';
import '../../../domain/services/text_layout_service.dart';
import 'note_editor_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  final TextLayoutService _layoutService;
  final _uuid = const Uuid();
  int _lastTextLength = 0;

  NoteEditorBloc({required TextLayoutService layoutService})
      : _layoutService = layoutService,
        super(NoteEditorInitial()) {
    on<LoadNoteDocument>(_onLoadDocument);
    on<UpdateNoteText>(_onUpdateText);
    on<StartStroke>(_onStartStroke);
    on<UpdateStroke>(_onUpdateStroke);
    on<EndStroke>(_onEndStroke);
    on<UpdateSelection>(_onUpdateSelection);
    on<ChangeTool>(_onChangeTool);
    on<ToggleFormat>(_onToggleFormat);
  }

  void _onLoadDocument(LoadNoteDocument event, Emitter<NoteEditorState> emit) {
    final textBlock = event.document.pages.firstOrNull?.blocks.whereType<TextBlock>().firstOrNull;
    _lastTextLength = textBlock?.content.plainText.length ?? 0;
    emit(NoteEditorLoaded(event.document));
  }

  void _onUpdateText(UpdateNoteText event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final doc = currentState.document;
    final selection = currentState.selection;

    final List<NotePage> newPages = List.from(doc.pages);
    final page = newPages[event.pageIndex];
    
    final List<NoteBlock> newBlocks = List.from(page.blocks);
    final blockIndex = newBlocks.indexWhere((b) => b.id == event.blockId);
    if (blockIndex == -1) return;

    final oldBlock = newBlocks[blockIndex] as TextBlock;
    final oldText = oldBlock.content.plainText;
    final newText = event.text;

    RichTextContent updatedContent;
    if (newText.length > oldText.length) {
      final insertedCount = newText.length - oldText.length;
      final insertionIndex = selection?.extentOffset ?? (newText.length - insertedCount);
      final insertedChars = newText.substring(insertionIndex - insertedCount, insertionIndex);
      
      updatedContent = oldBlock.content.insert(
        insertionIndex - insertedCount, 
        insertedChars, 
        currentState.activeTypingAttributes
      );
    } else if (newText.length < oldText.length) {
      final deletedCount = oldText.length - newText.length;
      final deletionIndex = selection?.extentOffset ?? newText.length;
      updatedContent = _deleteFromContent(oldBlock.content, deletionIndex, deletedCount);
    } else {
      updatedContent = oldBlock.content;
    }

    newBlocks[blockIndex] = oldBlock.copyWith(content: updatedContent);
    newPages[event.pageIndex] = page.copyWith(blocks: newBlocks);

    // --- PRO PAGINATION ENGINE ---
    int finalPageIndex = event.pageIndex;
    TextSelection? finalSelection = currentState.selection;
    
    // We need to track where the selection actually ended up after overflow
    if (finalSelection != null) {
      int currentOffset = finalSelection.extentOffset;
      
      // Iterate through pages and handle overflow while tracking selection
      for (int i = event.pageIndex; i < newPages.length; i++) {
        final p = newPages[i];
        final tBlocks = p.blocks.whereType<TextBlock>().toList();
        if (tBlocks.isEmpty) break;
        
        final mBlock = tBlocks.first;
        final result = _layoutService.layoutRichText(
          content: mBlock.content,
          maxWidth: p.width - mBlock.position.dx * 2,
          maxHeight: 1056.0 - mBlock.position.dy - 40.0, // Strict 40px bottom margin
          defaultStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, letterSpacing: 0.0),
        );

        final uBlocks = List<NoteBlock>.from(p.blocks);
        final mIdx = uBlocks.indexOf(mBlock);
        uBlocks[mIdx] = mBlock.copyWith(content: result.fittingContent);
        newPages[i] = p.copyWith(blocks: uBlocks);

        final fittingLength = result.fittingContent.plainText.length;

        if (result.remainingContent != null && result.remainingContent!.plainText.isNotEmpty) {
          // If the selection was in the overflow part, it moves to next page
          if (i == finalPageIndex && currentOffset > fittingLength) {
            finalPageIndex = i + 1;
            currentOffset -= fittingLength;
            finalSelection = TextSelection.collapsed(offset: currentOffset);
          } else if (i < finalPageIndex) {
            // If we are before the active page, any overflow here pushes the selection offset
            // (Standard document flow logic)
          }

          // Handle the actual content move
          if (i + 1 < newPages.length) {
            final nPage = newPages[i + 1];
            final nTBlocks = nPage.blocks.whereType<TextBlock>().toList();
            if (nTBlocks.isNotEmpty) {
              final nMain = nTBlocks.first;
              final nBlocks = List<NoteBlock>.from(nPage.blocks);
              final nIdx = nBlocks.indexOf(nMain);
              final merged = RichTextContent(segments: [...result.remainingContent!.segments, ...nMain.content.segments]).normalized();
              nBlocks[nIdx] = nMain.copyWith(content: merged);
              newPages[i + 1] = nPage.copyWith(blocks: nBlocks);
            } else {
              newPages[i + 1] = nPage.copyWith(blocks: [...nPage.blocks, TextBlock(id: _uuid.v4(), position: mBlock.position, size: mBlock.size, content: result.remainingContent!)]);
            }
          } else {
            newPages.add(NotePage(id: _uuid.v4(), blocks: [TextBlock(id: _uuid.v4(), position: mBlock.position, size: mBlock.size, content: result.remainingContent!)], width: p.width, height: p.height));
          }
        } else {
          // No more overflow, we can stop
          break;
        }
      }
    }

    _lastTextLength = newText.length;
    emit(currentState.copyWith(
      document: doc.copyWith(pages: newPages, updatedAt: DateTime.now()),
      selection: finalSelection,
      activePageIndex: finalPageIndex,
    ));
  }

  RichTextContent _deleteFromContent(RichTextContent content, int index, int count) {
    final text = content.plainText;
    if (index < 0 || index + count > text.length) return content;
    final before = content.getFitting(index);
    final after = content.splitAt(index + count);
    return RichTextContent(segments: [...before.segments, ...after.segments]).normalized();
  }

  void _onUpdateSelection(UpdateSelection event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;

    final doc = currentState.document;
    final page = doc.pages[event.pageIndex];
    final textBlock = page.blocks.whereType<TextBlock>().firstOrNull;
    final currentTextLength = textBlock?.content.plainText.length ?? 0;

    // RULE: If the selection moved but the text length also changed, it's a TYPING event.
    // We do NOT flush attributes during typing.
    final selectionMoved = currentState.selection?.extentOffset != event.selection.extentOffset;
    final textChanged = _lastTextLength != currentTextLength;

    TextSegment newAttributes = currentState.activeTypingAttributes;
    
    int finalPageIndex = event.pageIndex;
    TextSelection finalSelection = event.selection;

    if (selectionMoved && !textChanged) {
      // PRO ARROW-KEY PAGE JUMPING
      final textLength = textBlock?.content.plainText.length ?? 0;
      
      // Jump DOWN to next page
      if (event.selection.extentOffset == textLength && 
          currentState.selection?.extentOffset == textLength &&
          event.pageIndex < doc.pages.length - 1) {
        finalPageIndex = event.pageIndex + 1;
        finalSelection = const TextSelection.collapsed(offset: 0);
      }
      
      // Jump UP to previous page
      else if (event.selection.extentOffset == 0 && 
               currentState.selection?.extentOffset == 0 &&
               event.pageIndex > 0) {
        finalPageIndex = event.pageIndex - 1;
        final prevPage = doc.pages[finalPageIndex];
        final prevBlock = prevPage.blocks.whereType<TextBlock>().firstOrNull;
        finalSelection = TextSelection.collapsed(offset: prevBlock?.content.plainText.length ?? 0);
      }
      
      // Context-aware attribute update
      if (textBlock != null && finalSelection.isCollapsed) {
        final offset = finalSelection.extentOffset;
        newAttributes = textBlock.content.getAttributesAt(offset > 0 ? offset - 1 : 0);
      }
    }

    _lastTextLength = currentTextLength;
    emit(currentState.copyWith(
      selection: finalSelection,
      activePageIndex: finalPageIndex,
      activeTypingAttributes: newAttributes,
    ));
  }

  void _onToggleFormat(ToggleFormat event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final selection = currentState.selection;
    final pageIndex = currentState.activePageIndex;

    if (pageIndex == null) return;

    final currentAttr = currentState.activeTypingAttributes;
    final newAttr = currentAttr.copyWith(
      isBold: event.isBold != null ? !currentAttr.isBold : null,
      isItalic: event.isItalic != null ? !currentAttr.isItalic : null,
      isHeading: event.isHeading != null ? !currentAttr.isHeading : null,
    );

    if (selection == null || selection.isCollapsed) {
      emit(currentState.copyWith(activeTypingAttributes: newAttr));
    } else {
      final doc = currentState.document;
      final List<NotePage> newPages = List.from(doc.pages);
      final page = newPages[pageIndex];
      final textBlocks = page.blocks.whereType<TextBlock>().toList();
      if (textBlocks.isEmpty) return;

      final block = textBlocks.first;
      final updatedContent = _applyStyleToRange(block.content, selection.start, selection.end, event);

      final updatedBlocks = List<NoteBlock>.from(page.blocks);
      final blockIdx = updatedBlocks.indexOf(block);
      updatedBlocks[blockIdx] = block.copyWith(content: updatedContent);
      newPages[pageIndex] = page.copyWith(blocks: updatedBlocks);

      emit(currentState.copyWith(
        document: doc.copyWith(pages: newPages),
        activeTypingAttributes: newAttr,
      ));
    }
  }

  RichTextContent _applyStyleToRange(RichTextContent content, int start, int end, ToggleFormat toggle) {
    final before = content.getFitting(start);
    final target = content.splitAt(start).getFitting(end - start);
    final after = content.splitAt(end);
    final styledSegments = target.segments.map((s) {
      return s.copyWith(
        isBold: toggle.isBold != null ? !s.isBold : null,
        isItalic: toggle.isItalic != null ? !s.isItalic : null,
        isHeading: toggle.isHeading != null ? !s.isHeading : null,
      );
    }).toList();
    return RichTextContent(segments: [...before.segments, ...styledSegments, ...after.segments]).normalized();
  }

  void _onStartStroke(StartStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final newStroke = Stroke(points: [event.position], pressures: [event.pressure]);
    emit(currentState.copyWith(currentStroke: newStroke, activePageIndex: event.pageIndex));
  }

  void _onUpdateStroke(UpdateStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final stroke = currentState.currentStroke;
    if (stroke == null) return;
    final updatedStroke = stroke.copyWith(points: [...stroke.points, event.position], pressures: [...stroke.pressures, event.pressure]);
    emit(currentState.copyWith(currentStroke: updatedStroke));
  }

  void _onEndStroke(EndStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final stroke = currentState.currentStroke;
    final pageIndex = currentState.activePageIndex;
    if (stroke == null || pageIndex == null) return;
    final doc = currentState.document;
    final List<NotePage> newPages = List.from(doc.pages);
    final page = newPages[pageIndex];
    final List<NoteBlock> blocks = List.from(page.blocks);
    final canvasBlockIndex = blocks.indexWhere((b) => b is CanvasBlock);
    if (canvasBlockIndex != -1) {
      final canvasBlock = blocks[canvasBlockIndex] as CanvasBlock;
      blocks[canvasBlockIndex] = canvasBlock.copyWith(strokes: [...canvasBlock.strokes, stroke]);
    } else {
      blocks.add(CanvasBlock(id: _uuid.v4(), position: Offset.zero, size: Size(page.width, page.height), strokes: [stroke]));
    }
    newPages[pageIndex] = page.copyWith(blocks: blocks);
    emit(currentState.copyWith(document: doc.copyWith(pages: newPages, updatedAt: DateTime.now()), clearStroke: true));
  }

  void _onChangeTool(ChangeTool event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    emit((state as NoteEditorLoaded).copyWith(activeTool: event.tool));
  }
}
