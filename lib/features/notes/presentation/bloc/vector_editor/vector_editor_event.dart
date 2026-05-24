import 'dart:ui';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/vector_canvas/vector_note_document.dart';

enum VectorTool { pan, select, pen, eraser, text, photo, connector }

abstract class VectorEditorEvent extends Equatable {
  const VectorEditorEvent();

  @override
  List<Object?> get props => [];
}

class LoadVectorNote extends VectorEditorEvent {
  final VectorNoteDocument document;

  const LoadVectorNote(this.document);

  @override
  List<Object?> get props => [document];
}

class StartVectorStroke extends VectorEditorEvent {
  final Offset position;
  final double pressure;

  const StartVectorStroke({required this.position, required this.pressure});

  @override
  List<Object?> get props => [position, pressure];
}

class UpdateVectorStroke extends VectorEditorEvent {
  final Offset position;
  final double pressure;

  const UpdateVectorStroke({required this.position, required this.pressure});

  @override
  List<Object?> get props => [position, pressure];
}

class EndVectorStroke extends VectorEditorEvent {
  const EndVectorStroke();
}

class EraseAtVectorPosition extends VectorEditorEvent {
  final Offset position;
  const EraseAtVectorPosition(this.position);

  @override
  List<Object?> get props => [position];
}

class AddTextCard extends VectorEditorEvent {
  final Offset canvasPosition;
  final double scale;
  final String? id;
  const AddTextCard(this.canvasPosition, {this.scale = 1.0, this.id});

  @override
  List<Object?> get props => [canvasPosition, scale, id];
}

class UpdateTextCard extends VectorEditorEvent {
  final String id;
  final String content;
  final bool? isBold;
  final bool? isItalic;
  final double? fontSize;
  final int? textColorValue;

  const UpdateTextCard({
    required this.id,
    required this.content,
    this.isBold,
    this.isItalic,
    this.fontSize,
    this.textColorValue,
  });

  @override
  List<Object?> get props => [id, content, isBold, isItalic, fontSize, textColorValue];
}

class MoveElement extends VectorEditorEvent {
  final String id;
  final Offset newPosition;
  const MoveElement(this.id, this.newPosition);

  @override
  List<Object?> get props => [id, newPosition];
}

class AddPhotoNode extends VectorEditorEvent {
  final Offset canvasPosition;
  final String filePath;
  final double scale;
  const AddPhotoNode({required this.canvasPosition, required this.filePath, this.scale = 1.0});

  @override
  List<Object?> get props => [canvasPosition, filePath, scale];
}

class EstablishConnection extends VectorEditorEvent {
  final String sourceId;
  final String targetId;
  final Offset sourceAnchor;
  final Offset targetAnchor;

  const EstablishConnection({
    required this.sourceId,
    required this.targetId,
    required this.sourceAnchor,
    required this.targetAnchor,
  });

  @override
  List<Object?> get props => [sourceId, targetId, sourceAnchor, targetAnchor];
}

class ChangeVectorTool extends VectorEditorEvent {
  final VectorTool tool;
  const ChangeVectorTool(this.tool);

  @override
  List<Object?> get props => [tool];
}

class SelectElement extends VectorEditorEvent {
  final String? elementId;
  const SelectElement(this.elementId);

  @override
  List<Object?> get props => [elementId];
}

class DeleteElement extends VectorEditorEvent {
  final String id;
  const DeleteElement(this.id);

  @override
  List<Object?> get props => [id];
}

class ResizeElement extends VectorEditorEvent {
  final String id;
  final Size newSize;
  const ResizeElement(this.id, this.newSize);

  @override
  List<Object?> get props => [id, newSize];
}

class SaveVectorNote extends VectorEditorEvent {
  const SaveVectorNote();
}

class ToggleLockElement extends VectorEditorEvent {
  final String id;
  const ToggleLockElement(this.id);

  @override
  List<Object?> get props => [id];
}

class ChangeActiveGroup extends VectorEditorEvent {
  final String? activeGroupId;
  const ChangeActiveGroup(this.activeGroupId);

  @override
  List<Object?> get props => [activeGroupId];
}

class AddCanvasGroup extends VectorEditorEvent {
  final Offset canvasPosition;
  final double scale;
  final String? id;
  const AddCanvasGroup(this.canvasPosition, {this.scale = 1.0, this.id});

  @override
  List<Object?> get props => [canvasPosition, scale, id];
}
