import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'stroke.dart';
import 'text_content.dart';

enum BlockType { text, canvas, image, audio }

abstract class NoteBlock extends Equatable {
  final String id;
  final Offset position;
  final Size size;
  final double rotation;
  final double opacity;
  final bool isLocked;

  const NoteBlock({
    required this.id,
    required this.position,
    required this.size,
    this.rotation = 0.0,
    this.opacity = 1.0,
    this.isLocked = false,
  });

  NoteBlock copyWith({
    String? id,
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    bool? isLocked,
  });

  @override
  List<Object?> get props => [id, position, size, rotation, opacity, isLocked];
}

/// A block that contains rich text.
class TextBlock extends NoteBlock {
  final RichTextContent content; 

  const TextBlock({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.isLocked,
    required this.content,
  });

  @override
  TextBlock copyWith({
    String? id,
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    bool? isLocked,
    RichTextContent? content,
  }) {
    return TextBlock(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      isLocked: isLocked ?? this.isLocked,
      content: content ?? this.content,
    );
  }

  @override
  List<Object?> get props => [...super.props, content];
}

/// A block that contains drawing/ink data.
class CanvasBlock extends NoteBlock {
  final List<Stroke> strokes;

  const CanvasBlock({
    required super.id,
    required super.position,
    required super.size,
    super.rotation,
    super.opacity,
    super.isLocked,
    required this.strokes,
  });

  @override
  CanvasBlock copyWith({
    String? id,
    Offset? position,
    Size? size,
    double? rotation,
    double? opacity,
    bool? isLocked,
    List<Stroke>? strokes,
  }) {
    return CanvasBlock(
      id: id ?? this.id,
      position: position ?? this.position,
      size: size ?? this.size,
      rotation: rotation ?? this.rotation,
      opacity: opacity ?? this.opacity,
      isLocked: isLocked ?? this.isLocked,
      strokes: strokes ?? this.strokes,
    );
  }

  @override
  List<Object?> get props => [...super.props, strokes];
}
