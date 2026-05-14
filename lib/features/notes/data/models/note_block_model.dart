import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/note_block.dart';

part 'note_block_model.g.dart';

class OffsetConverter implements JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) => Offset(json['dx'] as double, json['dy'] as double);

  @override
  Map<String, dynamic> toJson(Offset object) => {'dx': object.dx, 'dy': object.dy};
}

class SizeConverter implements JsonConverter<Size, Map<String, dynamic>> {
  const SizeConverter();

  @override
  Size fromJson(Map<String, dynamic> json) => Size(json['width'] as double, json['height'] as double);

  @override
  Map<String, dynamic> toJson(Size object) => {'width': object.width, 'height': object.height};
}

class ColorConverter implements JsonConverter<Color, int> {
  const ColorConverter();

  @override
  Color fromJson(int json) => Color(json);

  @override
  int toJson(Color object) => object.value;
}

@JsonSerializable()
class StrokeModel extends Stroke {
  @override
  @OffsetConverter()
  final List<Offset> points;

  @override
  @ColorConverter()
  final Color color;

  @override
  final List<double> pressures;

  const StrokeModel({
    required this.points,
    required this.pressures,
    required this.color,
    double width = 2.0,
  }) : super(points: points, pressures: pressures, color: color, width: width);

  factory StrokeModel.fromEntity(Stroke stroke) {
    return StrokeModel(
      points: stroke.points,
      pressures: stroke.pressures,
      color: stroke.color,
      width: stroke.width,
    );
  }

  factory StrokeModel.fromJson(Map<String, dynamic> json) => _$StrokeModelFromJson(json);

  Map<String, dynamic> toJson() => _$StrokeModelToJson(this);
}

@JsonSerializable()
class TextBlockModel extends TextBlock {
  @override
  @OffsetConverter()
  final Offset position;

  @override
  @SizeConverter()
  final Size size;

  const TextBlockModel({
    required super.id,
    required this.position,
    required this.size,
    super.rotation,
    super.opacity,
    super.isLocked,
    required super.content,
  }) : super(position: position, size: size);

  factory TextBlockModel.fromEntity(TextBlock block) {
    return TextBlockModel(
      id: block.id,
      position: block.position,
      size: block.size,
      rotation: block.rotation,
      opacity: block.opacity,
      isLocked: block.isLocked,
      content: block.content,
    );
  }

  factory TextBlockModel.fromJson(Map<String, dynamic> json) => _$TextBlockModelFromJson(json);

  Map<String, dynamic> toJson() => _$TextBlockModelToJson(this)..['type'] = 'text';
}

@JsonSerializable()
class CanvasBlockModel extends CanvasBlock {
  @override
  @OffsetConverter()
  final Offset position;

  @override
  @SizeConverter()
  final Size size;

  @override
  @JsonKey(name: 'strokes')
  List<StrokeModel> get strokes => super.strokes.map((s) => StrokeModel.fromEntity(s)).toList();

  const CanvasBlockModel({
    required super.id,
    required this.position,
    required this.size,
    super.rotation,
    super.opacity,
    super.isLocked,
    required List<StrokeModel> strokes,
  }) : super(position: position, size: size, strokes: strokes);

  factory CanvasBlockModel.fromEntity(CanvasBlock block) {
    return CanvasBlockModel(
      id: block.id,
      position: block.position,
      size: block.size,
      rotation: block.rotation,
      opacity: block.opacity,
      isLocked: block.isLocked,
      strokes: block.strokes.map((s) => StrokeModel.fromEntity(s)).toList(),
    );
  }

  factory CanvasBlockModel.fromJson(Map<String, dynamic> json) {
    // Custom handling for the list of models
    final model = _$CanvasBlockModelFromJson(json);
    return model;
  }

  Map<String, dynamic> toJson() => _$CanvasBlockModelToJson(this)..['type'] = 'canvas';
}

class NoteBlockMapper {
  static NoteBlock fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String;
    switch (type) {
      case 'text':
        return TextBlockModel.fromJson(json);
      case 'canvas':
        return CanvasBlockModel.fromJson(json);
      default:
        throw Exception('Unknown block type: $type');
    }
  }

  static Map<String, dynamic> toJson(NoteBlock block) {
    if (block is TextBlock) {
      return TextBlockModel.fromEntity(block).toJson();
    } else if (block is CanvasBlock) {
      return CanvasBlockModel.fromEntity(block).toJson();
    }
    throw Exception('Unknown block type');
  }
}
