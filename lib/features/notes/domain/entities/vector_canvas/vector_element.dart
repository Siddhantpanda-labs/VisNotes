import 'dart:ui';

/// Base class representing any floating element on the infinite canvas.
sealed class VectorElement {
  final String id;
  final Offset position;
  final double scale;
  final double rotation;
  final bool isLocked;

  const VectorElement({
    required this.id,
    required this.position,
    this.scale = 1.0,
    this.rotation = 0.0,
    this.isLocked = false,
  });

  VectorElement copyWith({
    String? id,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isLocked,
  });
}

/// Represents a dynamic pressure-sensitive freehand vector drawing stroke on the canvas.
class VectorStrokeElement extends VectorElement {
  final List<Offset> points;
  final List<double> pressures;
  final int colorValue;
  final double strokeWidth;

  const VectorStrokeElement({
    required super.id,
    required super.position,
    required this.points,
    required this.pressures,
    required this.colorValue,
    required this.strokeWidth,
    super.scale = 1.0,
    super.rotation = 0.0,
    super.isLocked = false,
  });

  @override
  VectorStrokeElement copyWith({
    String? id,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isLocked,
    List<Offset>? points,
    List<double>? pressures,
    int? colorValue,
    double? strokeWidth,
  }) {
    return VectorStrokeElement(
      id: id ?? this.id,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isLocked: isLocked ?? this.isLocked,
      points: points ?? this.points,
      pressures: pressures ?? this.pressures,
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
    );
  }
}

/// Represents a sleek floating glassmorphic text card that can be placed anywhere.
class VectorTextElement extends VectorElement {
  final String text;
  final Size size;
  final int backgroundColorValue;
  final int textColorValue;
  final bool isBold;
  final bool isItalic;
  final double fontSize;

  const VectorTextElement({
    required super.id,
    required super.position,
    required this.text,
    required this.size,
    required this.backgroundColorValue,
    required this.textColorValue,
    this.isBold = false,
    this.isItalic = false,
    this.fontSize = 16.0,
    super.scale = 1.0,
    super.rotation = 0.0,
    super.isLocked = false,
  });

  @override
  VectorTextElement copyWith({
    String? id,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isLocked,
    String? text,
    Size? size,
    int? backgroundColorValue,
    int? textColorValue,
    bool? isBold,
    bool? isItalic,
    double? fontSize,
  }) {
    return VectorTextElement(
      id: id ?? this.id,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isLocked: isLocked ?? this.isLocked,
      text: text ?? this.text,
      size: size ?? this.size,
      backgroundColorValue: backgroundColorValue ?? this.backgroundColorValue,
      textColorValue: textColorValue ?? this.textColorValue,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      fontSize: fontSize ?? this.fontSize,
    );
  }
}

/// Represents an elegant, rounded imported photo panel floating on the canvas.
class VectorPhotoElement extends VectorElement {
  final String filePath;
  final Size size;

  const VectorPhotoElement({
    required super.id,
    required super.position,
    required this.filePath,
    required this.size,
    super.scale = 1.0,
    super.rotation = 0.0,
    super.isLocked = false,
  });

  @override
  VectorPhotoElement copyWith({
    String? id,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isLocked,
    String? filePath,
    Size? size,
  }) {
    return VectorPhotoElement(
      id: id ?? this.id,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isLocked: isLocked ?? this.isLocked,
      filePath: filePath ?? this.filePath,
      size: size ?? this.size,
    );
  }
}

/// Represents a rubber-band connection line bridging two distinct canvas nodes.
class VectorConnectorElement extends VectorElement {
  final String sourceId;
  final String targetId;
  
  /// Anchor offsets relative to the element center/top-left
  final Offset sourceAnchor;
  final Offset targetAnchor;
  
  final int colorValue;
  final double strokeWidth;
  final bool isDashed;

  const VectorConnectorElement({
    required super.id,
    required super.position,
    required this.sourceId,
    required this.targetId,
    required this.sourceAnchor,
    required this.targetAnchor,
    required this.colorValue,
    this.strokeWidth = 2.0,
    this.isDashed = false,
    super.scale = 1.0,
    super.rotation = 0.0,
    super.isLocked = false,
  });

  @override
  VectorConnectorElement copyWith({
    String? id,
    Offset? position,
    double? scale,
    double? rotation,
    bool? isLocked,
    String? sourceId,
    String? targetId,
    Offset? sourceAnchor,
    Offset? targetAnchor,
    int? colorValue,
    double? strokeWidth,
    bool? isDashed,
  }) {
    return VectorConnectorElement(
      id: id ?? this.id,
      position: position ?? this.position,
      scale: scale ?? this.scale,
      rotation: rotation ?? this.rotation,
      isLocked: isLocked ?? this.isLocked,
      sourceId: sourceId ?? this.sourceId,
      targetId: targetId ?? this.targetId,
      sourceAnchor: sourceAnchor ?? this.sourceAnchor,
      targetAnchor: targetAnchor ?? this.targetAnchor,
      colorValue: colorValue ?? this.colorValue,
      strokeWidth: strokeWidth ?? this.strokeWidth,
      isDashed: isDashed ?? this.isDashed,
    );
  }
}
