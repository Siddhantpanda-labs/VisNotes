// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TextSegment _$TextSegmentFromJson(Map<String, dynamic> json) => TextSegment(
      text: json['text'] as String,
      isBold: json['isBold'] as bool? ?? false,
      isItalic: json['isItalic'] as bool? ?? false,
      fontSize: (json['fontSize'] as num?)?.toDouble(),
      isHeading: json['isHeading'] as bool? ?? false,
    );

Map<String, dynamic> _$TextSegmentToJson(TextSegment instance) =>
    <String, dynamic>{
      'text': instance.text,
      'isBold': instance.isBold,
      'isItalic': instance.isItalic,
      'fontSize': instance.fontSize,
      'isHeading': instance.isHeading,
    };

RichTextContent _$RichTextContentFromJson(Map<String, dynamic> json) =>
    RichTextContent(
      segments: (json['segments'] as List<dynamic>)
          .map((e) => TextSegment.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RichTextContentToJson(RichTextContent instance) =>
    <String, dynamic>{
      'segments': instance.segments,
    };
