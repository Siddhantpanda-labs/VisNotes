import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';

class VectorCanvasPainter extends CustomPainter {
  final List<VectorElement> elements;
  final VectorStrokeElement? currentStroke;
  final String? selectedElementId;
  final String? editingElementId;
  final double scale;
  final Rect viewportRect;
  final Map<String, ui.Image> imageCache;

  VectorCanvasPainter({
    required this.elements,
    required this.scale,
    required this.viewportRect,
    required this.imageCache,
    this.currentStroke,
    this.selectedElementId,
    this.editingElementId,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Draw Grid Lines Background
    _paintGridLines(canvas, size);

    // 2. Draw Connector Lines (Background layer so they render behind host nodes)
    _paintConnectors(canvas);

    // 3. Draw Ink Strokes, Texts, Photos & Groups recursively
    _paintRecursive(canvas, elements, viewportRect, scale);

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
    // Find all connectors and nodes in flat space for rendering anchors
    final flatNodes = _flattenTree(elements);
    final aliveNodes = {for (var e in flatNodes) e.id: e};

    for (final elem in flatNodes) {
      if (elem is! VectorConnectorElement) continue;

      final source = aliveNodes[elem.sourceId];
      final target = aliveNodes[elem.targetId];
      if (source == null || target == null) continue;

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

      _drawArrowhead(canvas, pSource, pTarget, linePaint.color, elem.strokeWidth);
    }
  }

  void _paintRecursive(
    Canvas canvas,
    List<VectorElement> tree,
    Rect parentViewport,
    double currentGlobalScale,
  ) {
    for (final elem in tree) {
      // 1. Get Element Bounding Box
      final Rect bounds = _getElementBounds(elem);

      // 2. Frustum Culling
      if (!parentViewport.overlaps(bounds)) {
        continue;
      }

      // 3. Render based on element type and LOD
      if (elem is VectorStrokeElement) {
        if (elem.strokeWidth * currentGlobalScale < 0.15) continue;
        _paintStroke(canvas, elem);
      } else if (elem is VectorTextElement) {
        if (elem.id == selectedElementId && elem.id == editingElementId) {
          // Draw select ring only; textfield widget handles typing layout
          _paintSelectionRing(canvas, elem.position, elem.size);
          continue;
        }

        // Draw elegant card container background
        final bgPaint = Paint()
          ..color = Color(elem.backgroundColorValue)
          ..style = PaintingStyle.fill;
        
        final shadowPaint = Paint()
          ..color = Colors.black.withOpacity(0.04)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4.0);

        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
        canvas.drawRRect(RRect.fromRectAndRadius(rect.shift(const Offset(0, 2)), const Radius.circular(16)), shadowPaint);
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), bgPaint);

        // Draw text paragraph inside CustomPaint
        if (elem.text.isNotEmpty) {
          final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            fontSize: elem.fontSize,
            fontWeight: elem.isBold ? FontWeight.bold : FontWeight.normal,
            fontStyle: elem.isItalic ? FontStyle.italic : FontStyle.normal,
            fontFamily: 'Outfit',
          ))
            ..pushStyle(ui.TextStyle(color: Color(elem.textColorValue)))
            ..addText(elem.text);

          final paragraph = builder.build()
            ..layout(ui.ParagraphConstraints(width: elem.size.width - 24));

          canvas.drawParagraph(paragraph, elem.position + const Offset(12, 12));
        }

        if (elem.id == selectedElementId) {
          _paintSelectionRing(canvas, elem.position, elem.size);
        }
      } else if (elem is VectorPhotoElement) {
        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);

        final image = imageCache[elem.filePath];
        if (image != null) {
          canvas.save();
          final clipPath = Path()
            ..addRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)));
          canvas.clipPath(clipPath);

          canvas.drawImageRect(
            image,
            Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
            rect,
            Paint()..isAntiAlias = true,
          );
          canvas.restore();
        } else {
          // Loading card placeholder
          final bgPaint = Paint()
            ..color = const Color(0xFFF1F5F9)
            ..style = PaintingStyle.fill;
          canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(20)), bgPaint);

          final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
            fontSize: 12.0,
            fontFamily: 'Outfit',
            textAlign: TextAlign.center,
          ))
            ..pushStyle(ui.TextStyle(color: const Color(0xFF94A3B8)))
            ..addText('Photo Loading...');
          final paragraph = builder.build()
            ..layout(ui.ParagraphConstraints(width: elem.size.width));
          canvas.drawParagraph(paragraph, elem.position + Offset(0, elem.size.height / 2 - 6));
        }

        if (elem.id == selectedElementId) {
          _paintSelectionRing(canvas, elem.position, elem.size);
        }
      } else if (elem is VectorCanvasGroup) {
        final double screenWidth = elem.size.width * currentGlobalScale;

        if (screenWidth < 15) {
          // LOD 0: Group is too small to see, skip rendering completely
          continue;
        }

        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);

        if (screenWidth < 80) {
          // LOD 1: Simplified bounding box outline representing the nested canvas
          final boxPaint = Paint()
            ..color = const Color(0x1A6366F1)
            ..style = PaintingStyle.fill;
          final borderPaint = Paint()
            ..color = const Color(0xFF6366F1).withOpacity(0.3)
            ..strokeWidth = 1.0 / currentGlobalScale
            ..style = PaintingStyle.stroke;
          canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), boxPaint);
          canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(16)), borderPaint);

          if (elem.id == selectedElementId) {
            _paintSelectionRing(canvas, elem.position, elem.size);
          }
          continue;
        }

        // LOD 2: Full nested canvas group rendering with outline border
        final borderPaint = Paint()
          ..color = const Color(0xFF6366F1).withOpacity(0.08)
          ..strokeWidth = 2.0 / currentGlobalScale
          ..style = PaintingStyle.stroke;
        canvas.drawRRect(RRect.fromRectAndRadius(rect, const Radius.circular(24)), borderPaint);

        canvas.save();
        canvas.translate(elem.position.dx, elem.position.dy);
        canvas.scale(elem.scale);

        // Adjust viewport rect coordinates for nested child coordinates traversal
        final Rect localViewport = Rect.fromLTWH(
          (parentViewport.left - elem.position.dx) / elem.scale,
          (parentViewport.top - elem.position.dy) / elem.scale,
          parentViewport.width / elem.scale,
          parentViewport.height / elem.scale,
        );

        _paintRecursive(
          canvas,
          elem.children,
          localViewport,
          currentGlobalScale * elem.scale,
        );

        canvas.restore();

        if (elem.id == selectedElementId) {
          _paintSelectionRing(canvas, elem.position, elem.size);
        }
      }
    }
  }

  Rect _getElementBounds(VectorElement elem) {
    if (elem is VectorStrokeElement) {
      if (elem.points.isEmpty) return Rect.zero;
      double minX = elem.points[0].dx;
      double maxX = elem.points[0].dx;
      double minY = elem.points[0].dy;
      double maxY = elem.points[0].dy;
      for (final pt in elem.points) {
        if (pt.dx < minX) minX = pt.dx;
        if (pt.dx > maxX) maxX = pt.dx;
        if (pt.dy < minY) minY = pt.dy;
        if (pt.dy > maxY) maxY = pt.dy;
      }
      final double padding = elem.strokeWidth * 2.0;
      return Rect.fromLTRB(minX - padding, minY - padding, maxX + padding, maxY + padding);
    } else if (elem is VectorTextElement) {
      return Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
    } else if (elem is VectorPhotoElement) {
      return Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
    } else if (elem is VectorCanvasGroup) {
      return Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
    } else if (elem is VectorConnectorElement) {
      // Connectors span between two endpoints center points.
      return Rect.fromLTWH(elem.position.dx, elem.position.dy, 100, 100);
    }
    return Rect.zero;
  }

  List<VectorElement> _flattenTree(List<VectorElement> tree) {
    final List<VectorElement> flat = [];
    for (final elem in tree) {
      flat.add(elem);
      if (elem is VectorCanvasGroup) {
        flat.addAll(_flattenTree(elem.children));
      }
    }
    return flat;
  }

  void _paintStroke(Canvas canvas, VectorStrokeElement stroke) {
    if (stroke.points.isEmpty) return;

    final paint = Paint()
      ..color = Color(stroke.colorValue)
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < stroke.points.length - 1; i++) {
      final p1 = stroke.points[i];
      final p2 = stroke.points[i + 1];

      final pressure = stroke.pressures.length > i ? stroke.pressures[i] : 0.5;
      paint.strokeWidth = stroke.strokeWidth * (0.4 + pressure * 1.2);

      canvas.drawLine(p1, p2, paint);
    }
  }

  void _paintSelectionRing(Canvas canvas, Offset pos, Size size) {
    final double safeScale = scale > 0 ? scale : 1.0;
    final ringPaint = Paint()
      ..color = const Color(0xFF6366F1) // Indigo-500 selection theme
      ..strokeWidth = 2.0 / safeScale
      ..style = PaintingStyle.stroke;

    final double offset = 6.0 / safeScale;
    final rect = Rect.fromLTWH(
      pos.dx - offset,
      pos.dy - offset,
      size.width + (offset * 2),
      size.height + (offset * 2),
    );

    _drawDashedRect(
      canvas,
      rect,
      ringPaint,
      radius: 12.0 / safeScale,
      dashLength: 6.0 / safeScale,
      gapLength: 4.0 / safeScale,
    );

    final fillPaint = Paint()
      ..color = const Color(0xFF6366F1)
      ..style = PaintingStyle.fill;

    final double dotRadius = 4.0 / safeScale;
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
    } else if (elem is VectorCanvasGroup) {
      return elem.position + Offset(elem.size.width / 2, elem.size.height / 2);
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

  void _drawDashedRect(Canvas canvas, Rect rect, Paint paint, {double radius = 0.0, double dashLength = 6.0, double gapLength = 4.0}) {
    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(rect, Radius.circular(radius)));

    for (final contour in path.computeMetrics()) {
      double distance = 0.0;

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
        oldDelegate.editingElementId != editingElementId ||
        oldDelegate.scale != scale ||
        oldDelegate.viewportRect != viewportRect ||
        oldDelegate.imageCache.length != imageCache.length;
  }
}
