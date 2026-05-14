import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../data/mappers/note_mapper.dart';
import '../../../data/repositories/note_repository.dart';
import '../../../domain/entities/note_block.dart';
import '../../../domain/entities/note_document.dart';
import '../../../domain/entities/stroke.dart';
import '../../../domain/entities/text_content.dart';
import '../../../domain/services/text_layout_service.dart';
import '../../../domain/services/pagination_service.dart';
import 'note_editor_bloc_state.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class NoteEditorBloc extends Bloc<NoteEditorEvent, NoteEditorState> {
  final TextLayoutService _layoutService;
  final NotePaginationService _paginationService;
  final NoteRepository _noteRepository;
  int _lastTextLength = 0;

  NoteEditorBloc({
    required TextLayoutService layoutService,
    required NotePaginationService paginationService,
    required NoteRepository noteRepository,
  }) : _layoutService = layoutService,
       _paginationService = paginationService,
       _noteRepository = noteRepository,
       super(NoteEditorInitial()) {
    on<LoadNoteDocument>(_onLoadDocument);
    on<UpdateNoteText>(_onUpdateText);
    on<StartStroke>(_onStartStroke);
    on<UpdateStroke>(_onUpdateStroke);
    on<EndStroke>(_onEndStroke);
    on<UpdateSelection>(_onUpdateSelection);
    on<ChangeTool>(_onChangeTool);
    on<ToggleFormat>(_onToggleFormat);
    on<EraseAtPosition>(_onEraseAtPosition);
    on<SaveNote>(
      _onSaveNote,
      transformer: _debounce(const Duration(milliseconds: 1500)),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  void _onLoadDocument(LoadNoteDocument event, Emitter<NoteEditorState> emit) {
    final textBlock = event.document.pages.firstOrNull?.blocks
        .whereType<TextBlock>()
        .firstOrNull;
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

    int commonPrefix = 0;
    while (commonPrefix < oldText.length &&
        commonPrefix < newText.length &&
        oldText[commonPrefix] == newText[commonPrefix]) {
      commonPrefix++;
    }

    int commonSuffix = 0;
    while (commonSuffix < oldText.length - commonPrefix &&
        commonSuffix < newText.length - commonPrefix &&
        oldText[oldText.length - 1 - commonSuffix] ==
            newText[newText.length - 1 - commonSuffix]) {
      commonSuffix++;
    }

    final deletedCount = oldText.length - commonPrefix - commonSuffix;
    final insertedCount = newText.length - commonPrefix - commonSuffix;

    RichTextContent updatedContent = oldBlock.content;

    if (deletedCount > 0) {
      updatedContent = _deleteFromContent(updatedContent, commonPrefix, deletedCount);
    }

    if (insertedCount > 0) {
      final insertedChars = newText.substring(commonPrefix, commonPrefix + insertedCount);
      updatedContent = updatedContent.insert(
        commonPrefix,
        insertedChars,
        currentState.activeTypingAttributes,
      );
    }

    newBlocks[blockIndex] = oldBlock.copyWith(content: updatedContent);
    newPages[event.pageIndex] = page.copyWith(blocks: newBlocks);

    final result = _paginationService.reflowText(
      pages: newPages,
      currentPageIndex: event.pageIndex,
      blockId: event.blockId,
      currentSelection: event.selection ?? currentState.selection,
    );

    _lastTextLength = newText.length;
    emit(
      currentState.copyWith(
        document: doc.copyWith(pages: result.pages, updatedAt: DateTime.now()),
        selection: result.selection,
        activePageIndex: result.activePageIndex,
      ),
    );

    // Auto-trigger save after debounce
    add(const SaveNote());
  }

  Future<void> _onSaveNote(
    SaveNote event,
    Emitter<NoteEditorState> emit,
  ) async {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;

    final isarDoc = NoteMapper.toIsar(currentState.document);
    await _noteRepository.saveNote(isarDoc);
    debugPrint('Note Auto-Saved: ${currentState.document.id}');
  }

  RichTextContent _deleteFromContent(
    RichTextContent content,
    int index,
    int count,
  ) {
    final text = content.plainText;
    if (index < 0 || index + count > text.length) return content;
    final before = content.getFitting(index);
    final after = content.splitAt(index + count);
    return RichTextContent(
      segments: [...before.segments, ...after.segments],
    ).normalized();
  }

  void _onUpdateSelection(
    UpdateSelection event,
    Emitter<NoteEditorState> emit,
  ) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;

    final doc = currentState.document;
    final page = doc.pages[event.pageIndex];
    final textBlock = page.blocks.whereType<TextBlock>().firstOrNull;
    final currentTextLength = textBlock?.content.plainText.length ?? 0;

    final selectionMoved = currentState.selection != event.selection;
    final textChanged = _lastTextLength != currentTextLength;

    TextSegment newAttributes = currentState.activeTypingAttributes;
    int finalPageIndex = event.pageIndex;
    TextSelection finalSelection = event.selection;

    if (selectionMoved && !textChanged) {
      final textLength = textBlock?.content.plainText.length ?? 0;

      if (event.selection.extentOffset == textLength &&
          currentState.selection?.extentOffset == textLength &&
          event.pageIndex < doc.pages.length - 1) {
        finalPageIndex = event.pageIndex + 1;
        finalSelection = const TextSelection.collapsed(offset: 0);
      } else if (event.selection.extentOffset == 0 &&
          currentState.selection?.extentOffset == 0 &&
          event.pageIndex > 0) {
        finalPageIndex = event.pageIndex - 1;
        final prevPage = doc.pages[finalPageIndex];
        final prevBlock = prevPage.blocks.whereType<TextBlock>().firstOrNull;
        finalSelection = TextSelection.collapsed(
          offset: prevBlock?.content.plainText.length ?? 0,
        );
      }

      if (textBlock != null) {
        final checkOffset = finalSelection.isCollapsed
            ? (finalSelection.extentOffset > 0 ? finalSelection.extentOffset - 1 : 0)
            : finalSelection.start;
            
        newAttributes = textBlock.content.getAttributesAt(checkOffset);
      }
    }

    _lastTextLength = currentTextLength;
    emit(
      currentState.copyWith(
        selection: finalSelection,
        activePageIndex: finalPageIndex,
        activeTypingAttributes: newAttributes,
      ),
    );
  }

  void _onToggleFormat(ToggleFormat event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    final selection = currentState.selection;
    final pageIndex = currentState.activePageIndex;

    if (pageIndex == null) return;

    final currentAttr = currentState.activeTypingAttributes;
    final isHeadingNow = event.isHeading != null ? !currentAttr.isHeading : null;
    final newAttr = currentAttr.copyWith(
      isBold: event.isBold != null ? !currentAttr.isBold : null,
      isItalic: event.isItalic != null ? !currentAttr.isItalic : null,
      isHeading: isHeadingNow,
      fontSize: isHeadingNow != null ? (isHeadingNow ? 24.0 : 16.0) : currentAttr.fontSize,
    );

    if (selection != null && !selection.isCollapsed) {
      final doc = currentState.document;
      final List<NotePage> newPages = List.from(doc.pages);
      final page = newPages[pageIndex];
      final List<NoteBlock> newBlocks = List.from(page.blocks);
      final textBlock = newBlocks.whereType<TextBlock>().firstOrNull;

      if (textBlock != null) {
        final blockIdx = newBlocks.indexOf(textBlock);
        newBlocks[blockIdx] = textBlock.copyWith(
          content: textBlock.content.applyFormat(
            selection.start,
            selection.end,
            isBold: event.isBold != null ? !currentAttr.isBold : null,
            isItalic: event.isItalic != null ? !currentAttr.isItalic : null,
            isHeading: isHeadingNow,
          ),
        );
        
        // Explicitly update font sizes in the selected segments
        if (isHeadingNow != null) {
           final tb = newBlocks[blockIdx] as TextBlock;
           final updatedSegments = tb.content.segments.map((seg) {
             if (seg.isHeading == isHeadingNow) {
               return seg.copyWith(fontSize: isHeadingNow ? 24.0 : 16.0);
             }
             return seg;
           }).toList();
           newBlocks[blockIdx] = tb.copyWith(
             content: RichTextContent(segments: updatedSegments).normalized()
           );
        }

        newPages[pageIndex] = page.copyWith(blocks: newBlocks);

        // Reflow is mandatory after formatting changes as text size might change!
        final result = _paginationService.reflowText(
          pages: newPages,
          currentPageIndex: pageIndex,
          blockId: textBlock.id,
          currentSelection: currentState.selection,
        );

        emit(
          currentState.copyWith(
            document: doc.copyWith(pages: result.pages, updatedAt: DateTime.now()),
            activeTypingAttributes: newAttr,
            selection: result.selection,
            activePageIndex: result.activePageIndex,
          ),
        );
        add(const SaveNote());
      }
    } else {
      emit(currentState.copyWith(activeTypingAttributes: newAttr));
    }
  }

  void _onChangeTool(ChangeTool event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    emit((state as NoteEditorLoaded).copyWith(activeTool: event.tool));
  }

  void _onStartStroke(StartStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final stroke = Stroke(
      points: [event.position],
      pressures: [event.pressure],
      color: Colors.black,
      width: 2.5,
    );
    emit(
      (state as NoteEditorLoaded).copyWith(
        currentStroke: stroke,
        activePageIndex: event.pageIndex,
      ),
    );
  }

  void _onUpdateStroke(UpdateStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    if (currentState.currentStroke == null) return;

    final updatedStroke = currentState.currentStroke!.copyWith(
      points: [...currentState.currentStroke!.points, event.position],
      pressures: [...currentState.currentStroke!.pressures, event.pressure],
    );
    emit(currentState.copyWith(currentStroke: updatedStroke));
  }

  void _onEndStroke(EndStroke event, Emitter<NoteEditorState> emit) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;
    
    if (currentState.activePageIndex == null) return;

    if (currentState.currentStroke == null) {
      // If we were erasing, just clear the eraser circle
      emit(currentState.copyWith(clearEraser: true));
      return;
    }

    final doc = currentState.document;
    final List<NotePage> newPages = List.from(doc.pages);
    final pageIdx = currentState.activePageIndex!;
    final page = newPages[pageIdx];

    final List<NoteBlock> newBlocks = List.from(page.blocks);
    final canvasBlock = newBlocks.whereType<CanvasBlock>().firstOrNull;

    if (canvasBlock != null) {
      final idx = newBlocks.indexOf(canvasBlock);
      newBlocks[idx] = canvasBlock.copyWith(
        strokes: [...canvasBlock.strokes, currentState.currentStroke!],
      );
    } else {
      newBlocks.add(
        CanvasBlock(
          id: const Uuid().v4(),
          position: Offset.zero,
          size: Size(page.width, page.height),
          strokes: [currentState.currentStroke!],
        ),
      );
    }

    newPages[pageIdx] = page.copyWith(blocks: newBlocks);
    emit(
      currentState.copyWith(
        document: doc.copyWith(pages: newPages, updatedAt: DateTime.now()),
        clearStroke: true,
        clearEraser: true,
      ),
    );
    add(const SaveNote());
  }

  void _onEraseAtPosition(
    EraseAtPosition event,
    Emitter<NoteEditorState> emit,
  ) {
    if (state is! NoteEditorLoaded) return;
    final currentState = state as NoteEditorLoaded;

    final doc = currentState.document;
    final List<NotePage> newPages = List.from(doc.pages);
    final page = newPages[event.pageIndex];
    final List<NoteBlock> newBlocks = List.from(page.blocks);
    final canvasBlock = newBlocks.whereType<CanvasBlock>().firstOrNull;

    if (canvasBlock == null) return;

    final updatedStrokes = List<Stroke>.from(canvasBlock.strokes);
    bool changed = false;

    updatedStrokes.removeWhere((stroke) {
      bool isHit = false;
      if (stroke.points.isEmpty) return false;
      if (stroke.points.length == 1) {
         isHit = (stroke.points.first - event.position).distance < 35;
      } else {
         for (int i = 0; i < stroke.points.length - 1; i++) {
           final p1 = stroke.points[i];
           final p2 = stroke.points[i + 1];
           final l2 = (p1 - p2).distanceSquared;
           if (l2 == 0) continue;
           
           var t = ((event.position.dx - p1.dx) * (p2.dx - p1.dx) + 
                    (event.position.dy - p1.dy) * (p2.dy - p1.dy)) / l2;
           t = t.clamp(0.0, 1.0);
           final projection = Offset(p1.dx + t * (p2.dx - p1.dx), p1.dy + t * (p2.dy - p1.dy));
           
           if ((event.position - projection).distance < 35) {
             isHit = true;
             break;
           }
         }
      }
      if (isHit) changed = true;
      return isHit;
    });

    if (changed) {
      final idx = newBlocks.indexOf(canvasBlock);
      newBlocks[idx] = canvasBlock.copyWith(strokes: updatedStrokes);
      newPages[event.pageIndex] = page.copyWith(blocks: newBlocks);
      emit(
        currentState.copyWith(
          document: doc.copyWith(pages: newPages, updatedAt: DateTime.now()),
          eraserPosition: event.position,
          activePageIndex: event.pageIndex,
        ),
      );
      add(const SaveNote());
    } else {
      emit(
        currentState.copyWith(
          eraserPosition: event.position,
          activePageIndex: event.pageIndex,
        ),
      );
    }
  }
}
