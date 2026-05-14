import 'package:flutter/material.dart';
import '../../../domain/entities/text_content.dart';

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
