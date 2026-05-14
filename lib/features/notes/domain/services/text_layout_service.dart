import 'package:flutter/material.dart';
import '../entities/text_content.dart';

class TextLayoutResult {
  final RichTextContent fittingContent;
  final RichTextContent? remainingContent;
  final double totalHeight;
  final List<LineMetrics> lines;
  final TextPainter textPainter;

  TextLayoutResult({
    required this.fittingContent,
    this.remainingContent,
    required this.totalHeight,
    required this.lines,
    required this.textPainter,
  });
}

class CaretMetrics {
  final Offset offset;
  final double height;

  CaretMetrics({required this.offset, required this.height});
}

class TextLayoutService {
  TextPainter _createTextPainter(RichTextContent content, TextStyle defaultStyle, double maxWidth) {
    final tp = TextPainter(
      text: TextSpan(
        children: content.segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: defaultStyle.copyWith(
              fontFamily: 'Roboto',
              fontWeight: segment.isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: segment.isItalic ? FontStyle.italic : FontStyle.normal,
              fontSize: segment.isHeading ? (segment.fontSize ?? 24) : (segment.fontSize ?? 16),
              color: segment.color,
              letterSpacing: 0.0,
              height: 1.2,
            ),
          );
        }).toList(),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
      strutStyle: const StrutStyle(
        fontFamily: 'Roboto',
        fontSize: 16, // Lock the baseline grid!
        height: 1.2,
        forceStrutHeight: false,
      ),
    );
    tp.layout(maxWidth: maxWidth);
    return tp;
  }

  TextLayoutResult layoutRichText({
    required RichTextContent content,
    required double maxWidth,
    required double maxHeight,
    required TextStyle defaultStyle,
  }) {
    final textPainter = _createTextPainter(content, defaultStyle, maxWidth);

    // Pagination logic
    final lines = textPainter.computeLineMetrics();
    double currentHeight = 0;
    int splitCharIndex = content.plainText.length;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (currentHeight + line.height > maxHeight) {
        splitCharIndex = textPainter.getPositionForOffset(Offset(0, currentHeight)).offset;
        break;
      }
      currentHeight += line.height;
    }

    if (splitCharIndex < content.plainText.length) {
      return TextLayoutResult(
        fittingContent: content.getFitting(splitCharIndex),
        remainingContent: content.splitAt(splitCharIndex),
        totalHeight: currentHeight,
        lines: lines,
        textPainter: textPainter,
      );
    }

    return TextLayoutResult(
      fittingContent: content,
      totalHeight: textPainter.height,
      lines: lines,
      textPainter: textPainter,
    );
  }

  CaretMetrics getCaretMetrics({
    required RichTextContent content,
    required int charOffset,
    required double maxWidth,
    required TextStyle defaultStyle,
  }) {
    final textPainter = _createTextPainter(content, defaultStyle, maxWidth);
    final textPosition = TextPosition(
      offset: charOffset,
      affinity: TextAffinity.upstream,
    );

    // Ask the TextPainter for the exact caret position — same layout pass, guaranteed correct.
    final caretOffset = textPainter.getOffsetForCaret(textPosition, Rect.zero);

    // Ask the TextPainter for the exact measured height of the glyph at this position.
    // This is the ONLY correct source of truth — no guessing from segment attributes.
    final fullHeight = textPainter.getFullHeightForCaret(textPosition, Rect.zero);
    final caretHeight = fullHeight ?? 16.0 * 1.2; // fallback if no glyphs yet

    return CaretMetrics(offset: caretOffset, height: caretHeight);
  }

  /// Maps a tap position (local to the text block) to a character offset.
  /// Uses the SAME TextPainter as [getCaretMetrics] — this is the single source
  /// of truth for all text layout, ensuring tap→offset and offset→caret are
  /// always consistent with each other and with the visual rendering.
  int getPositionForOffset({
    required RichTextContent content,
    required Offset localTapPosition,
    required double maxWidth,
    required TextStyle defaultStyle,
  }) {
    final textPainter = _createTextPainter(content, defaultStyle, maxWidth);
    final position = textPainter.getPositionForOffset(localTapPosition);
    return position.offset;
  }


  /// Calculates a list of rectangles that represent the selection highlight
  List<Rect> getSelectionRects({
    required RichTextContent content,
    required TextSelection selection,
    required double maxWidth,
    required TextStyle defaultStyle,
  }) {
    if (selection.isCollapsed) return [];
    
    final textPainter = _createTextPainter(content, defaultStyle, maxWidth);
    final boxes = textPainter.getBoxesForSelection(selection);
    
    return boxes.map((box) => box.toRect()).toList();
  }
}
