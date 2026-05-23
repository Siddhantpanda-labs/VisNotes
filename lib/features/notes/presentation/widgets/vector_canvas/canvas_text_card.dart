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
    return OverflowBox(
      alignment: Alignment.topLeft,
      minWidth: elem.size.width * cardScale,
      maxWidth: elem.size.width * cardScale,
      minHeight: elem.size.height * cardScale,
      maxHeight: elem.size.height * cardScale,
      child: Transform.scale(
        scale: 1.0 / cardScale,
        alignment: Alignment.topLeft,
        child: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            color: Color(elem.backgroundColorValue),
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 15.0,
                offset: const Offset(0, 6.0),
              )
            ],
            border: Border.all(
              color: Colors.black.withOpacity(0.06),
              width: 1.0,
            ),
          ),
          child: isEditing
              ? ScrollbarTheme(
                  data: ScrollbarThemeData(
                    thickness: WidgetStateProperty.all(6.0),
                    radius: const Radius.circular(3.0),
                    thumbColor: WidgetStateProperty.all(const Color(0x33000000)),
                  ),
                  child: TextField(
                    controller: controller,
                    maxLines: null,
                    autofocus: true,
                    cursorWidth: 2.0,
                    cursorRadius: const Radius.circular(1.0),
                    style: GoogleFonts.outfit(
                      fontSize: elem.fontSize * cardScale,
                      fontWeight: elem.isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: elem.isItalic ? FontStyle.italic : FontStyle.normal,
                      color: Color(elem.textColorValue),
                      letterSpacing: 0.0,
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
                      fontSize: elem.fontSize * cardScale,
                      fontWeight: elem.isBold ? FontWeight.bold : FontWeight.normal,
                      fontStyle: elem.isItalic ? FontStyle.italic : FontStyle.normal,
                      color: elem.text.isEmpty
                          ? Color(elem.textColorValue).withOpacity(0.4)
                          : Color(elem.textColorValue),
                      letterSpacing: 0.0,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
