import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';

class VectorCanvasPainter extends CustomPainter {
  final List<VectorElement> elements;
  final VectorStrokeElement? currentStroke;
  final String? selectedElementId;
  final double scale;

  VectorCanvasPainter({
    required this.elements,
    required this.scale,
    this.currentStroke,
    this.selectedElementId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Grid Lines Background
    _paintGridLines(canvas, size);

    // 2. Draw Connector Lines (Background layer so they render behind host nodes)
    _paintConnectors(canvas);

    // 3. Draw Ink Strokes & Elements
    _paintElements(canvas);

    // 4. Draw Active In-Progress Stroke
    if (currentStroke != null) {
      _paintStroke(canvas, currentStroke!);
    }
  }

  void _paintGridLines(Canvas canvas, Size size) {
    double safeScale = scale;
    if (safeScale <= 0.01 || safeScale.isNaN || safeScale.isInfinite) {
      safeScale = 1.0;
    }

    const double baseSpacing = 50.0;
    
    final linePaint = Paint()
      ..color = const Color(0x1D0F172A) // Sleek slate-900 grid lines (11% opacity for ultra-clean visibility)
      ..strokeWidth = 1.0 / safeScale   // Scale-compensated to keep screen thickness constant!
      ..style = PaintingStyle.stroke;

    final subLinePaint = Paint()
      ..strokeWidth = 0.5 / safeScale   // Scale-compensated to keep screen thickness constant!
      ..style = PaintingStyle.stroke;

    // Logarithmic scale estimation
    final double logScale = math.log(safeScale) / math.log(2.0);
    // Clamp level to range [-2, 1] to bound rendering complexity
    final int level = logScale.floor().clamp(-2, 1);
    
    final double spacing = baseSpacing * math.pow(2.0, -level);
    
    // Draw vertical grid lines
    for (double x = 0.0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), linePaint);
    }
    
    // Draw horizontal grid lines
    for (double y = 0.0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    // Finer sub-grid divisions & opacity fade-in
    final double fract = logScale - level;
    final double subGridOpacity = fract.clamp(0.0, 1.0);
    
    if (subGridOpacity > 0.1) {
      subLinePaint.color = const Color(0x1D0F172A).withOpacity(subGridOpacity * 0.35);
      final double subSpacing = spacing / 2.0;
      
      for (double x = 0.0; x < size.width; x += subSpacing) {
        final bool isPrimary = (x % spacing).abs() < 0.1;
        if (isPrimary) continue;
        canvas.drawLine(Offset(x, 0), Offset(x, size.height), subLinePaint);
      }
      
      for (double y = 0.0; y < size.height; y += subSpacing) {
        final bool isPrimary = (y % spacing).abs() < 0.1;
        if (isPrimary) continue;
        canvas.drawLine(Offset(0, y), Offset(size.width, y), subLinePaint);
      }
    }
  }

  void _paintConnectors(Canvas canvas) {
    final aliveNodes = {for (var e in elements) e.id: e};

    for (final elem in elements) {
      if (elem is! VectorConnectorElement) continue;

      final source = aliveNodes[elem.sourceId];
      final target = aliveNodes[elem.targetId];
      if (source == null || target == null) continue;

      // Calculate center points of source/target nodes
      final pSource = _getElementCenter(source);
      final pTarget = _getElementCenter(target);

      final linePaint = Paint()
        ..color = Color(elem.colorValue)
        ..strokeWidth = elem.strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (elem.isDashed) {
        _drawDashedLine(canvas, pSource, pTarget, linePaint);
      } else {
        canvas.drawLine(pSource, pTarget, linePaint);
      }

      // Draw elegant arrowhead at the target side
      _drawArrowhead(canvas, pSource, pTarget, linePaint.color, elem.strokeWidth);
    }
  }

  void _paintElements(Canvas canvas) {
    for (final elem in elements) {
      if (elem is VectorStrokeElement) {
        _paintStroke(canvas, elem);
      } else if (elem is VectorTextElement) {
        // Text rendering is handled by interactive Flutter Widgets placed on top of CustomPaint
        // to support editable text inputs and rich text rendering.
        // We only paint a clean selection ring here if selected.
        if (elem.id == selectedElementId) {
          _paintSelectionRing(canvas, elem.position, elem.size);
        }
      } else if (elem is VectorPhotoElement) {
        // Photo node: painted via widgets layer.
        // Paint selection ring here if selected.
        if (elem.id == selectedElementId) {
          _paintSelectionRing(canvas, elem.position, elem.size);
        }
      }
    }
  }

  void _paintStroke(Canvas canvas, VectorStrokeElement stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = Color(stroke.colorValue)
      ..strokeCap = StrokeCap.round;

    // Draw stroke with simulated tapered lines using pressure mapping
    for (int i = 0; i < stroke.points.length - 1; i++) {
      final p1 = stroke.points[i];
      final p2 = stroke.points[i + 1];

      final pressure = stroke.pressures.length > i ? stroke.pressures[i] : 0.5;
      // Pressure range typically 0.0 to 1.0. Apply standard scaling.
      paint.strokeWidth = stroke.strokeWidth * (0.4 + pressure * 1.2);

      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintSelectionRing(Canvas canvas, Offset pos, Size size) {
    final ringPaint = Paint()
      ..color = const Color(0xFF6366F1) // Indigo-500 selection theme
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    final rect = Rect.fromLTWH(
      pos.dx - 6,
      pos.dy - 6,
      size.width + 12,
      size.height + 12,
    );

    // Draw dashed selection rectangle with smooth rounded corners
    _drawDashedRect(canvas, rect, ringPaint, radius: 12.0);

    // Draw little accent resizing/editing grab anchors at the corners
    final fillPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    final double dotRadius = 4.0;
    canvas.drawCircle(rect.topLeft, dotRadius, fillPaint);
    canvas.drawCircle(rect.topRight, dotRadius, fillPaint);
    canvas.drawCircle(rect.bottomLeft, dotRadius, fillPaint);
    canvas.drawCircle(rect.bottomRight, dotRadius, fillPaint);
  }

  Offset _getElementCenter(VectorElement elem) {
    if (elem is VectorTextElement) {
      return elem.position + Offset(elem.size.width / 2, elem.size.height / 2);
    } else if (elem is VectorPhotoElement) {
      return elem.position + Offset(elem.size.width / 2, elem.size.height / 2);
    } else if (elem is VectorStrokeElement) {
      return elem.position;
    }
    return elem.position;
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    final distance = (p2 - p1).distance;
    final direction = (p2 - p1) / distance;
    const dashLength = 8.0;
    const gapLength = 6.0;

    double drawn = 0.0;
    while (drawn < distance) {
      final currentStart = p1 + direction * drawn;
      final remaining = distance - drawn;
      final currentDash = remaining < dashLength ? remaining : dashLength;
      
      canvas.drawLine(
        currentStart,
        currentStart + direction * currentDash,
        paint,
      );

      drawn += dashLength + gapLength;
    }
  }

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint, {double radius = 0.0}) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final contour in path.computeMetrics()) {
      double distance = 0.0;
      const dashLength = 6.0;
      const gapLength = 4.0;

      while (distance < contour.length) {
        final length = math.min(dashLength, contour.length - distance);
        final extract = contour.extractPath(distance, distance + length);
        canvas.drawPath(extract, paint);
        distance += dashLength + gapLength;
      }
    }
  }

  void _drawArrowhead(Canvas canvas, Offset source, Offset target, Color color, double strokeWidth) {
    final angle = math.atan2(target.dy - source.dy, target.dx - source.dx);
    final double arrowSize = 12.0 + strokeWidth;

    // Shift target back slightly to prevent arrowhead overlapping cards directly
    final targetShift = target - Offset(math.cos(angle) * 8, math.sin(angle) * 8);

    final path = Path()
      ..moveTo(targetShift.dx, targetShift.dy)
      ..lineTo(
        targetShift.dx - arrowSize * math.cos(angle - math.pi / 6),
        targetShift.dy - arrowSize * math.sin(angle - math.pi / 6),
      )
      ..lineTo(
        targetShift.dx - arrowSize * math.cos(angle + math.pi / 6),
        targetShift.dy - arrowSize * math.sin(angle + math.pi / 6),
      )
      ..close();

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant VectorCanvasPainter oldDelegate) {
    return oldDelegate.elements != elements ||
        oldDelegate.currentStroke != currentStroke ||
        oldDelegate.selectedElementId != selectedElementId ||
        oldDelegate.scale != scale;
  }
}
