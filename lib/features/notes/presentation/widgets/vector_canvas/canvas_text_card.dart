import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visnotes/features/notes/domain/entities/vector_canvas/vector_element.dart';

class CanvasTextCard extends StatelessWidget {
  final VectorTextElement elem;
  final bool isEditing;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onSubmitted;

  const CanvasTextCard({
    super.key,
    required this.elem,
    required this.isEditing,
    required this.controller,
    required this.onChanged,
    required this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    final double cardScale = elem.scale > 0 ? elem.scale : 1.0;
    return Container(
      padding: EdgeInsets.all(12.0 / cardScale),
      decoration: BoxDecoration(
        color: Color(elem.backgroundColorValue),
        borderRadius: BorderRadius.circular(16.0 / cardScale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15.0 / cardScale,
            offset: Offset(0, 6.0 / cardScale),
          )
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1.0 / cardScale,
        ),
      ),
      child: isEditing
          ? ScrollbarTheme(
              data: ScrollbarThemeData(
                thickness: WidgetStateProperty.all(6.0 / cardScale),
                radius: Radius.circular(3.0 / cardScale),
                thumbColor: WidgetStateProperty.all(const Color(0x33000000)),
              ),
              child: TextField(
                controller: controller,
                maxLines: null,
                autofocus: true,
                cursorWidth: 2.0 / cardScale,
                cursorRadius: Radius.circular(1.0 / cardScale),
                style: GoogleFonts.outfit(
                  fontSize: elem.fontSize,
                  fontWeight: elem.isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: elem.isItalic ? FontStyle.italic : FontStyle.normal,
                  color: Color(elem.textColorValue),
                ),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
                onChanged: onChanged,
                onSubmitted: (_) => onSubmitted(),
              ),
            )
          : Center(
              child: Text(
                elem.text.isEmpty ? "Double tap to type..." : elem.text,
                textAlign: TextAlign.center,
                style: GoogleFonts.outfit(
                  fontSize: elem.fontSize,
                  fontWeight: elem.isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: elem.isItalic ? FontStyle.italic : FontStyle.normal,
                  color: elem.text.isEmpty
                      ? Color(elem.textColorValue).withOpacity(0.4)
                      : Color(elem.textColorValue),
                ),
              ),
            ),
    );
  }
}
