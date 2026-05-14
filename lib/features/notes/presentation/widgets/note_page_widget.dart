import 'package:flutter/material.dart';
import '../../domain/entities/note_document.dart';
import 'page_painter.dart';

class NotePageWidget extends StatelessWidget {
  final NotePage page;
  final bool showGrid;

  const NotePageWidget({
    super.key,
    required this.page,
    this.showGrid = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: page.width,
      height: page.height,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        size: Size(page.width, page.height),
        painter: PagePainter(page: page, showGrid: showGrid),
      ),
    );
  }
}
