import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../entities/note_block.dart';
import '../entities/note_document.dart';
import '../entities/text_content.dart';
import 'text_layout_service.dart';

class PaginationResult {
  final List<NotePage> pages;
  final int activePageIndex;
  final TextSelection? selection;

  PaginationResult({
    required this.pages,
    required this.activePageIndex,
    this.selection,
  });
}

class NotePaginationService {
  final TextLayoutService _layoutService;
  final _uuid = const Uuid();

  NotePaginationService({required TextLayoutService layoutService})
      : _layoutService = layoutService;

  PaginationResult reflowText({
    required List<NotePage> pages,
    required int currentPageIndex,
    required String blockId,
    required TextSelection? currentSelection,
  }) {
    final List<NotePage> newPages = List.from(pages);
    int finalPageIndex = currentPageIndex;
    TextSelection? finalSelection = currentSelection;
    
    if (finalSelection == null) {
      return PaginationResult(pages: newPages, activePageIndex: finalPageIndex);
    }

    int currentOffset = finalSelection.extentOffset;
    
    // Iterate through pages and dynamically Push/Pull text to maintain perfect pagination
    for (int i = currentPageIndex; i < newPages.length; i++) {
      final p = newPages[i];
      final tBlocks = p.blocks.whereType<TextBlock>().toList();
      if (tBlocks.isEmpty) continue;
      
      final mBlock = tBlocks.first;
      RichTextContent currentContent = mBlock.content;

      // PULL MECHANIC: Grab text from the next page to ensure we fill any gaps on this page
      if (i + 1 < newPages.length) {
        final nPage = newPages[i + 1];
        final nTBlocks = nPage.blocks.whereType<TextBlock>().toList();
        if (nTBlocks.isNotEmpty) {
          final nextContent = nTBlocks.first.content;
          if (nextContent.plainText.isNotEmpty) {
            currentContent = RichTextContent(segments: [...currentContent.segments, ...nextContent.segments]).normalized();
            
            // Temporarily clear the next page so we don't duplicate if nothing overflows
            final nBlocks = List<NoteBlock>.from(nPage.blocks);
            final nIdx = nBlocks.indexOf(nTBlocks.first);
            nBlocks[nIdx] = nTBlocks.first.copyWith(content: const RichTextContent(segments: []));
            newPages[i + 1] = nPage.copyWith(blocks: nBlocks);
          }
        }
      }

      final result = _layoutService.layoutRichText(
        content: currentContent,
        maxWidth: p.width - mBlock.position.dx * 2,
        maxHeight: p.height - mBlock.position.dy - 40.0, // Strict 40px bottom margin
        defaultStyle: const TextStyle(fontFamily: 'Roboto', fontSize: 16, letterSpacing: 0.0),
      );

      final uBlocks = List<NoteBlock>.from(p.blocks);
      final mIdx = uBlocks.indexOf(mBlock);
      uBlocks[mIdx] = mBlock.copyWith(content: result.fittingContent);
      newPages[i] = p.copyWith(blocks: uBlocks);

      final fittingLength = result.fittingContent.plainText.length;

      if (result.remainingContent != null && result.remainingContent!.plainText.isNotEmpty) {
        // Track Caret Migration
        if (i == finalPageIndex && currentOffset > fittingLength) {
          finalPageIndex = i + 1;
          currentOffset -= fittingLength;
          finalSelection = TextSelection.collapsed(offset: currentOffset);
        }

        // PUSH MECHANIC: Send the remainder to the next page
        if (i + 1 < newPages.length) {
          final nPage = newPages[i + 1];
          final nTBlocks = nPage.blocks.whereType<TextBlock>().toList();
          if (nTBlocks.isNotEmpty) {
            final nMain = nTBlocks.first;
            final nBlocks = List<NoteBlock>.from(nPage.blocks);
            final nIdx = nBlocks.indexOf(nMain);
            nBlocks[nIdx] = nMain.copyWith(content: result.remainingContent!);
            newPages[i + 1] = nPage.copyWith(blocks: nBlocks);
          }
        } else {
          // Generate a new sheet if we run out of pages
          newPages.add(NotePage(
            id: _uuid.v4(), 
            blocks: [
              TextBlock(
                id: _uuid.v4(), 
                position: mBlock.position, 
                size: mBlock.size, 
                content: result.remainingContent!
              )
            ], 
            width: p.width, 
            height: p.height
          ));
        }
      } else {
        // If no overflow, and we pulled everything, the reflow is complete.
        break;
      }
    }

    // Cleanup: Remove any trailing empty pages that were drained during the Pull mechanic
    while (newPages.length > 1) {
      final lastPage = newPages.last;
      final tBlocks = lastPage.blocks.whereType<TextBlock>().toList();
      if (tBlocks.isNotEmpty && tBlocks.first.content.plainText.isEmpty) {
        newPages.removeLast();
      } else {
        break;
      }
    }

    return PaginationResult(
      pages: newPages,
      activePageIndex: finalPageIndex,
      selection: finalSelection,
    );
  }
}
