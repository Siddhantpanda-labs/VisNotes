import 'package:flutter/material.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';

class PagePainter extends CustomPainter {
  final NotePage page;
  final TextSelection? selection;
  final List<Rect>? selectionRects;
  final Offset? caretOffset;
  final double? caretHeight;
  final bool isCaretVisible;
  final bool showGrid;
  final bool drawBackground;

  PagePainter({
    required this.page,
    this.selection,
    this.selectionRects,
    this.caretOffset,
    this.caretHeight,
    this.isCaretVisible = false,
    this.showGrid = true,
    this.drawBackground = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (drawBackground) {
      // 1. Draw Page Background
      final paint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

      // 2. Draw Shadow/Border
      final borderPaint = Paint()
        ..color = Colors.black12
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), borderPaint);
    }

    if (showGrid && drawBackground) {
      _drawGrid(canvas, size);
    }

    // 3. Draw Blocks
    for (final block in page.blocks) {
      _drawBlock(canvas, block);
    }
  }

  void _drawGrid(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.blue.withOpacity(0.05)
      ..strokeWidth = 1.0;

    const spacing = 20.0;
    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
  }

  void _drawBlock(Canvas canvas, NoteBlock block) {
    canvas.save();
    
    // Apply transformations: Position and Rotation
    canvas.translate(block.position.dx, block.position.dy);
    canvas.rotate(block.rotation);

    if (block is TextBlock) {
      _drawTextBlock(canvas, block);
    } else if (block is CanvasBlock) {
      _drawCanvasBlock(canvas, block);
    }

    canvas.restore();
  }

  void _drawTextBlock(Canvas canvas, TextBlock block) {
    // 1. Draw Selection Highlights (Behind text)
    if (selectionRects != null && selectionRects!.isNotEmpty) {
      final selectionPaint = Paint()
        ..color = Colors.blue.withOpacity(0.2)
        ..style = PaintingStyle.fill;
      for (final rect in selectionRects!) {
        canvas.drawRect(rect, selectionPaint);
      }
    }

    // 2. Draw Text
    final textPainter = TextPainter(
      text: TextSpan(
        children: block.content.segments.map((segment) {
          return TextSpan(
            text: segment.text,
            style: TextStyle(
              fontFamily: 'Roboto',
              color: segment.color ?? Colors.black,
              fontSize: segment.isHeading ? (segment.fontSize ?? 24) : (segment.fontSize ?? 16),
              fontWeight: segment.isBold ? FontWeight.bold : FontWeight.normal,
              fontStyle: segment.isItalic ? FontStyle.italic : FontStyle.normal,
              height: 1.2,
              letterSpacing: 0.0,
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
    textPainter.layout(maxWidth: block.size.width);
    textPainter.paint(canvas, Offset.zero);

    // 3. Draw Custom Caret (On top)
    if (isCaretVisible && caretOffset != null && caretHeight != null) {
      final caretPaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 2.0;
      
      canvas.drawLine(caretOffset!, caretOffset! + Offset(0, caretHeight!), caretPaint);
    }
  }

  void _drawCanvasBlock(Canvas canvas, CanvasBlock block) {
    for (final stroke in block.strokes) {
      if (stroke.points.isEmpty) continue;

      final paint = Paint()
        ..color = stroke.color
        ..strokeWidth = stroke.width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..style = PaintingStyle.stroke;

      final path = Path();
      path.moveTo(stroke.points.first.dx, stroke.points.first.dy);

      for (int i = 1; i < stroke.points.length; i++) {
        path.lineTo(stroke.points[i].dx, stroke.points[i].dy);
      }
      
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant PagePainter oldDelegate) {
    return oldDelegate.page != page || 
           oldDelegate.showGrid != showGrid || 
           oldDelegate.drawBackground != drawBackground ||
           oldDelegate.selection != selection ||
           oldDelegate.caretOffset != caretOffset ||
           oldDelegate.isCaretVisible != isCaretVisible;
  }
}
