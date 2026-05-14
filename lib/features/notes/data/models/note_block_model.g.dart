// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_block_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StrokeModel _$StrokeModelFromJson(Map<String, dynamic> json) => StrokeModel(
  points: (json['points'] as List<dynamic>)
      .map((e) => const OffsetConverter().fromJson(e as Map<String, dynamic>))
      .toList(),
  pressures: (json['pressures'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
  color: const ColorConverter().fromJson((json['color'] as num).toInt()),
  width: (json['width'] as num?)?.toDouble() ?? 2.0,
);

Map<String, dynamic> _$StrokeModelToJson(StrokeModel instance) =>
    <String, dynamic>{
      'pressures': instance.pressures,
      'width': instance.width,
      'points': instance.points.map(const OffsetConverter().toJson).toList(),
      'color': const ColorConverter().toJson(instance.color),
    };

TextBlockModel _$TextBlockModelFromJson(Map<String, dynamic> json) =>
    TextBlockModel(
      id: json['id'] as String,
      position: const OffsetConverter().fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      size: const SizeConverter().fromJson(
        json['size'] as Map<String, dynamic>,
      ),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      isLocked: json['isLocked'] as bool? ?? false,
      content: json['content'] as String,
    );

Map<String, dynamic> _$TextBlockModelToJson(TextBlockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rotation': instance.rotation,
      'opacity': instance.opacity,
      'isLocked': instance.isLocked,
      'content': instance.content,
      'position': const OffsetConverter().toJson(instance.position),
      'size': const SizeConverter().toJson(instance.size),
    };

CanvasBlockModel _$CanvasBlockModelFromJson(Map<String, dynamic> json) =>
    CanvasBlockModel(
      id: json['id'] as String,
      position: const OffsetConverter().fromJson(
        json['position'] as Map<String, dynamic>,
      ),
      size: const SizeConverter().fromJson(
        json['size'] as Map<String, dynamic>,
      ),
      rotation: (json['rotation'] as num?)?.toDouble() ?? 0.0,
      opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
      isLocked: json['isLocked'] as bool? ?? false,
      strokes: (json['strokes'] as List<dynamic>)
          .map((e) => StrokeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CanvasBlockModelToJson(CanvasBlockModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'rotation': instance.rotation,
      'opacity': instance.opacity,
      'isLocked': instance.isLocked,
      'position': const OffsetConverter().toJson(instance.position),
      'size': const SizeConverter().toJson(instance.size),
      'strokes': instance.strokes,
    };
