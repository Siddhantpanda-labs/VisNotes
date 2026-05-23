import 'dart:io';
import 'package:flutter/material.dart';
import 'package:visnotes/features/notes/domain/entities/vector_canvas/vector_element.dart';

class CanvasPhotoCard extends StatelessWidget {
  final VectorPhotoElement elem;

  const CanvasPhotoCard({
    super.key,
    required this.elem,
  });

  @override
  Widget build(BuildContext context) {
    final double cardScale = elem.scale > 0 ? elem.scale : 1.0;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0 / cardScale),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18.0 / cardScale,
            offset: Offset(0, 8.0 / cardScale),
          )
        ],
        border: Border.all(
          color: Colors.black.withOpacity(0.06),
          width: 1.0 / cardScale,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19.0 / cardScale),
        child: elem.filePath.startsWith('http')
            ? Image.network(elem.filePath, fit: BoxFit.cover)
            : Image.file(File(elem.filePath), fit: BoxFit.cover),
      ),
    );
  }
}
