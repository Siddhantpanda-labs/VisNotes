import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import '../../../domain/entities/note_document.dart';
import '../../../domain/entities/stroke.dart';
import '../../../domain/entities/text_content.dart';

abstract class NoteEditorEvent extends Equatable {
  const NoteEditorEvent();

  @override
  List<Object?> get props => [];
}

class LoadNoteDocument extends NoteEditorEvent {
  final NoteDocument document;

  const LoadNoteDocument(this.document);

  @override
  List<Object?> get props => [document];
}

class UpdateNoteText extends NoteEditorEvent {
  final String text;
  final int pageIndex;
  final String blockId;

  const UpdateNoteText({
    required this.text,
    required this.pageIndex,
    required this.blockId,
  });

  @override
  List<Object?> get props => [text, pageIndex, blockId];
}

class StartStroke extends NoteEditorEvent {
  final Offset position;
  final double pressure;
  final int pageIndex;

  const StartStroke({
    required this.position,
    required this.pressure,
    required this.pageIndex,
  });

  @override
  List<Object?> get props => [position, pressure, pageIndex];
}

class UpdateStroke extends NoteEditorEvent {
  final Offset position;
  final double pressure;

  const UpdateStroke({
    required this.position,
    required this.pressure,
  });

  @override
  List<Object?> get props => [position, pressure];
}

class EndStroke extends NoteEditorEvent {
  const EndStroke();
}

class EraseAtPosition extends NoteEditorEvent {
  final Offset position;
  final int pageIndex;

  const EraseAtPosition({required this.position, required this.pageIndex});

  @override
  List<Object?> get props => [position, pageIndex];
}

enum EditorTool { select, pen, eraser }

class ToggleFormat extends NoteEditorEvent {
  final bool? isBold;
  final bool? isItalic;
  final bool? isHeading;

  const ToggleFormat({this.isBold, this.isItalic, this.isHeading});

  @override
  List<Object?> get props => [isBold, isItalic, isHeading];
}

class ChangeTool extends NoteEditorEvent {
  final EditorTool tool;
  const ChangeTool(this.tool);

  @override
  List<Object?> get props => [tool];
}

class UpdateSelection extends NoteEditorEvent {
  final TextSelection selection;
  final int pageIndex;

  const UpdateSelection({required this.selection, required this.pageIndex});

  @override
  List<Object?> get props => [selection, pageIndex];
}

abstract class NoteEditorState extends Equatable {
  const NoteEditorState();

  @override
  List<Object?> get props => [];
}

class NoteEditorInitial extends NoteEditorState {}

class NoteEditorLoaded extends NoteEditorState {
  final NoteDocument document;
  final Stroke? currentStroke;
  final int? activePageIndex;
  final TextSelection? selection;
  final EditorTool activeTool;
  final TextSegment activeTypingAttributes;

  final Offset? eraserPosition;

  const NoteEditorLoaded(
    this.document, {
    this.currentStroke,
    this.activePageIndex,
    this.selection,
    this.activeTool = EditorTool.select,
    this.activeTypingAttributes = const TextSegment(text: ''),
    this.eraserPosition,
  });

  NoteEditorLoaded copyWith({
    NoteDocument? document,
    Stroke? currentStroke,
    bool clearStroke = false,
    int? activePageIndex,
    TextSelection? selection,
    EditorTool? activeTool,
    TextSegment? activeTypingAttributes,
    Offset? eraserPosition,
    bool clearEraser = false,
  }) {
    return NoteEditorLoaded(
      document ?? this.document,
      currentStroke: clearStroke ? null : (currentStroke ?? this.currentStroke),
      activePageIndex: activePageIndex ?? this.activePageIndex,
      selection: selection ?? this.selection,
      activeTool: activeTool ?? this.activeTool,
      activeTypingAttributes: activeTypingAttributes ?? this.activeTypingAttributes,
      eraserPosition: clearEraser ? null : (eraserPosition ?? this.eraserPosition),
    );
  }

  @override
  List<Object?> get props => [
        document,
        currentStroke,
        activePageIndex,
        selection,
        activeTool,
        activeTypingAttributes,
        eraserPosition,
      ];
}
