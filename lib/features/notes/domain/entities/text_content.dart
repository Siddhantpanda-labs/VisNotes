import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'text_content.g.dart';

@JsonSerializable()
class TextSegment extends Equatable {
  final String text;
  final bool isBold;
  final bool isItalic;
  final double? fontSize;
  @JsonKey(includeFromJson: false, includeToJson: false) // Color is tricky in JSON
  final Color? color;
  final bool isHeading;

  const TextSegment({
    required this.text,
    this.isBold = false,
    this.isItalic = false,
    this.fontSize,
    this.color,
    this.isHeading = false,
  });

  bool hasSameStyle(TextSegment other) {
    return isBold == other.isBold &&
        isItalic == other.isItalic &&
        fontSize == other.fontSize &&
        color == other.color &&
        isHeading == other.isHeading;
  }

  TextSegment copyWith({
    String? text,
    bool? isBold,
    bool? isItalic,
    double? fontSize,
    Color? color,
    bool? isHeading,
  }) {
    return TextSegment(
      text: text ?? this.text,
      isBold: isBold ?? this.isBold,
      isItalic: isItalic ?? this.isItalic,
      fontSize: fontSize ?? this.fontSize,
      color: color ?? this.color,
      isHeading: isHeading ?? this.isHeading,
    );
  }

  @override
  List<Object?> get props => [text, isBold, isItalic, fontSize, color, isHeading];

  factory TextSegment.fromJson(Map<String, dynamic> json) => _$TextSegmentFromJson(json);
  Map<String, dynamic> toJson() => _$TextSegmentToJson(this);
}

@JsonSerializable()
class RichTextContent extends Equatable {
  final List<TextSegment> segments;

  const RichTextContent({required this.segments});

  factory RichTextContent.fromJson(Map<String, dynamic> json) => _$RichTextContentFromJson(json);
  Map<String, dynamic> toJson() => _$RichTextContentToJson(this);

  String get plainText => segments.map((s) => s.text).join();

  /// Returns a normalized version of the content (merges adjacent identical segments)
  RichTextContent normalized() {
    if (segments.isEmpty) return this;
    final List<TextSegment> normalized = [];
    TextSegment? current;

    for (final segment in segments) {
      if (segment.text.isEmpty) continue;
      if (current == null) {
        current = segment;
      } else if (current.hasSameStyle(segment)) {
        current = current.copyWith(text: current.text + segment.text);
      } else {
        normalized.add(current);
        current = segment;
      }
    }
    if (current != null) normalized.add(current);
    return RichTextContent(segments: normalized);
  }

  /// Finds the attributes at a specific character offset
  TextSegment getAttributesAt(int offset) {
    if (segments.isEmpty) return const TextSegment(text: '');
    if (offset == 0) return segments.first;

    int currentOffset = 0;
    for (final segment in segments) {
      if (currentOffset + segment.text.length >= offset) {
        return segment;
      }
      currentOffset += segment.text.length;
    }
    return segments.last;
  }

  /// Inserts text at the given offset with the specified attributes
  RichTextContent insert(int offset, String newText, TextSegment attributes) {
    int currentOffset = 0;
    final List<TextSegment> newSegments = [];
    bool inserted = false;

    if (offset == 0) {
      newSegments.add(attributes.copyWith(text: newText));
      newSegments.addAll(segments);
      inserted = true;
    } else {
      for (final segment in segments) {
        if (!inserted && currentOffset + segment.text.length >= offset) {
          final splitPoint = offset - currentOffset;
          // Before the split
          if (splitPoint > 0) {
            newSegments.add(segment.copyWith(text: segment.text.substring(0, splitPoint)));
          }
          // The new insertion
          newSegments.add(attributes.copyWith(text: newText));
          // After the split
          if (splitPoint < segment.text.length) {
            newSegments.add(segment.copyWith(text: segment.text.substring(splitPoint)));
          }
          inserted = true;
        } else {
          newSegments.add(segment);
        }
        currentOffset += segment.text.length;
      }
    }

    if (!inserted) {
      newSegments.add(attributes.copyWith(text: newText));
    }

    return RichTextContent(segments: newSegments).normalized();
  }

  /// Splits the content at a character offset (used for pagination)
  RichTextContent getFitting(int offset) {
    int currentOffset = 0;
    final List<TextSegment> fitting = [];
    for (final segment in segments) {
      if (currentOffset + segment.text.length <= offset) {
        fitting.add(segment);
        currentOffset += segment.text.length;
      } else if (currentOffset < offset) {
        fitting.add(segment.copyWith(text: segment.text.substring(0, offset - currentOffset)));
        break;
      } else break;
    }
    return RichTextContent(segments: fitting).normalized();
  }

  RichTextContent splitAt(int offset) {
    int currentOffset = 0;
    final List<TextSegment> remaining = [];
    for (final segment in segments) {
      if (currentOffset + segment.text.length > offset) {
        final start = (offset - currentOffset).clamp(0, segment.text.length);
        remaining.add(segment.copyWith(text: segment.text.substring(start)));
      }
      currentOffset += segment.text.length;
    }
    return RichTextContent(segments: remaining).normalized();
  }

  RichTextContent applyFormat(int start, int end, {bool? isBold, bool? isItalic, bool? isHeading}) {
    if (start >= end) return this;
    
    final List<TextSegment> newSegments = [];
    int currentOffset = 0;
    
    for (final segment in segments) {
      final segmentEnd = currentOffset + segment.text.length;
      
      if (segmentEnd <= start || currentOffset >= end) {
        // Entirely outside
        newSegments.add(segment);
      } else {
        // Partially or entirely inside
        final overlapStart = start > currentOffset ? start - currentOffset : 0;
        final overlapEnd = end < segmentEnd ? end - currentOffset : segment.text.length;
        
        // Before overlap
        if (overlapStart > 0) {
          newSegments.add(segment.copyWith(text: segment.text.substring(0, overlapStart)));
        }
        
        // The overlap part
        newSegments.add(segment.copyWith(
          text: segment.text.substring(overlapStart, overlapEnd),
          isBold: isBold ?? segment.isBold,
          isItalic: isItalic ?? segment.isItalic,
          isHeading: isHeading ?? segment.isHeading,
        ));
        
        // After overlap
        if (overlapEnd < segment.text.length) {
          newSegments.add(segment.copyWith(text: segment.text.substring(overlapEnd)));
        }
      }
      currentOffset += segment.text.length;
    }
    
    return RichTextContent(segments: newSegments).normalized();
  }

  @override
  List<Object?> get props => [segments];
}
