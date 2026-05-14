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
            ),
          );
        }).toList(),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.left,
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
    TextSegment? activeAttributes,
  }) {
    final textPainter = _createTextPainter(content, defaultStyle, maxWidth);
    // Use upstream affinity to prevent jumping to the wrong line at wrap boundaries
    final caretOffset = textPainter.getOffsetForCaret(
      TextPosition(offset: charOffset, affinity: TextAffinity.upstream), 
      Rect.zero
    );
    
    // Use the actively held attributes or look ahead at the character the cursor is on
    final segment = activeAttributes ?? content.getAttributesAt(charOffset);
    final caretHeight = segment.isHeading ? 24.0 * 1.2 : 16.0 * 1.2;

    // Find the line this caret is on to find the "floor"
    final lines = textPainter.computeLineMetrics();
    double cumulativeHeight = 0;
    double lineBottom = caretOffset.dy + caretHeight; // Default fallback

    for (var line in lines) {
      // Use tighter float tolerance to prevent jumping to upper rows
      if (caretOffset.dy >= cumulativeHeight - 0.5 && caretOffset.dy < cumulativeHeight + line.height - 0.5) {
        lineBottom = cumulativeHeight + line.height;
        break;
      }
      cumulativeHeight += line.height;
    }

    // Anchor the caret to the bottom of the line
    return CaretMetrics(
      offset: Offset(caretOffset.dx, lineBottom - caretHeight), 
      height: caretHeight
    );
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
