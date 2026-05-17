import 'dart:ui';
import 'package:equatable/equatable.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';
import '../../../domain/entities/vector_canvas/vector_note_document.dart';
import 'vector_editor_event.dart';

abstract class VectorEditorState extends Equatable {
  const VectorEditorState();

  @override
  List<Object?> get props => [];
}

class VectorEditorInitial extends VectorEditorState {}

class VectorEditorLoaded extends VectorEditorState {
  final VectorNoteDocument document;
  final VectorStrokeElement? currentStroke;
  final VectorTool activeTool;
  final String? selectedElementId;
  final Offset? eraserPosition;
  
  // Connectors
  final String? connectorSourceId;
  final Offset? connectorSourceAnchor;
  final Offset? connectorCurrentPoint;

  const VectorEditorLoaded({
    required this.document,
    this.currentStroke,
    this.activeTool = VectorTool.pan,
    this.selectedElementId,
    this.eraserPosition,
    this.connectorSourceId,
    this.connectorSourceAnchor,
    this.connectorCurrentPoint,
  });

  VectorEditorLoaded copyWith({
    VectorNoteDocument? document,
    VectorStrokeElement? currentStroke,
    bool clearStroke = false,
    VectorTool? activeTool,
    String? selectedElementId,
    bool clearSelectedElement = false,
    Offset? eraserPosition,
    bool clearEraser = false,
    
    // Connectors
    String? connectorSourceId,
    bool clearConnectorSource = false,
    Offset? connectorSourceAnchor,
    Offset? connectorCurrentPoint,
    bool clearConnectorCurrent = false,
  }) {
    return VectorEditorLoaded(
      document: document ?? this.document,
      currentStroke: clearStroke ? null : (currentStroke ?? this.currentStroke),
      activeTool: activeTool ?? this.activeTool,
      selectedElementId: clearSelectedElement ? null : (selectedElementId ?? this.selectedElementId),
      eraserPosition: clearEraser ? null : (eraserPosition ?? this.eraserPosition),
      connectorSourceId: clearConnectorSource ? null : (connectorSourceId ?? this.connectorSourceId),
      connectorSourceAnchor: clearConnectorSource ? null : (connectorSourceAnchor ?? this.connectorSourceAnchor),
      connectorCurrentPoint: clearConnectorCurrent ? null : (connectorCurrentPoint ?? this.connectorCurrentPoint),
    );
  }

  @override
  List<Object?> get props => [
        document,
        currentStroke,
        activeTool,
        selectedElementId,
        eraserPosition,
        connectorSourceId,
        connectorSourceAnchor,
        connectorCurrentPoint,
      ];
}
