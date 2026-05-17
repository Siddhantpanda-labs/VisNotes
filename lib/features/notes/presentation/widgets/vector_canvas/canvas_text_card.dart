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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(elem.backgroundColorValue),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1.0,
        ),
      ),
      child: isEditing
          ? TextField(
              controller: controller,
              maxLines: null,
              autofocus: true,
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
