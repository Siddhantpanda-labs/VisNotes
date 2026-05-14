import 'package:flutter/material.dart';
import '../entities/text_content.dart';

class TextLayoutResult {
  final RichTextContent fittingContent;
  final RichTextContent? remainingContent;
  final double height;

  const TextLayoutResult({
    required this.fittingContent,
    this.remainingContent,
    required this.height,
  });
}

class TextLayoutService {
  /// Measures rich text and splits it if it exceeds [maxHeight].
  TextLayoutResult layoutRichText({
    required RichTextContent content,
    required double maxWidth,
    required double maxHeight,
    required TextStyle defaultStyle,
  }) {
    final textPainter = TextPainter(
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
    );

    textPainter.layout(maxWidth: maxWidth);

    if (textPainter.height <= maxHeight) {
      return TextLayoutResult(
        fittingContent: content,
        height: textPainter.height,
      );
    }

    // Find the split point using line metrics from TextPainter
    final List<LineMetrics> lines = textPainter.computeLineMetrics();
    double currentHeight = 0;
    int splitCharOffset = 0;

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i];
      if (currentHeight + line.height > maxHeight) {
        // We found the overflow line. 
        // We take the character offset before this line starts.
        // LineMetrics doesn't directly give char offset in some versions, 
        // so we use getPositionForOffset.
        final pos = textPainter.getPositionForOffset(Offset(0, currentHeight));
        splitCharOffset = pos.offset;
        break;
      }
      currentHeight += line.height;
    }

    if (splitCharOffset == 0) {
      return TextLayoutResult(
        fittingContent: const RichTextContent(segments: []),
        remainingContent: content,
        height: 0,
      );
    }

    return TextLayoutResult(
      fittingContent: content.getFitting(splitCharOffset),
      remainingContent: content.splitAt(splitCharOffset),
      height: currentHeight,
    );
  }
}
