import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../../../data/repositories/vector_note_repository.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';
import '../../../domain/entities/vector_canvas/vector_note_document.dart';
import 'vector_editor_event.dart';
import 'vector_editor_state.dart';

class VectorEditorBloc extends Bloc<VectorEditorEvent, VectorEditorState> {
  final VectorNoteRepository _vectorNoteRepository;
  final _uuid = const Uuid();

  VectorEditorBloc({
    required VectorNoteRepository vectorNoteRepository,
  })  : _vectorNoteRepository = vectorNoteRepository,
        super(VectorEditorInitial()) {
    on<LoadVectorNote>(_onLoadVectorNote);
    on<StartVectorStroke>(_onStartVectorStroke);
    on<UpdateVectorStroke>(_onUpdateVectorStroke);
    on<EndVectorStroke>(_onEndStroke);
    on<EraseAtVectorPosition>(_onEraseAtPosition);
    on<AddTextCard>(_onAddTextCard);
    on<UpdateTextCard>(_onUpdateTextCard);
    on<MoveElement>(_onMoveElement);
    on<AddPhotoNode>(_onAddPhotoNode);
    on<EstablishConnection>(_onEstablishConnection);
    on<ChangeVectorTool>(_onChangeTool);
    on<SelectElement>(_onSelectElement);
    on<DeleteElement>(_onDeleteElement);
    on<ResizeElement>(_onResizeElement);
    on<ToggleLockElement>(_onToggleLockElement);
    
    // Auto-save transformer
    on<SaveVectorNote>(
      _onSaveVectorNote,
      transformer: _debounce(const Duration(milliseconds: 1000)),
    );
  }

  EventTransformer<T> _debounce<T>(Duration duration) {
    return (events, mapper) => events.debounceTime(duration).flatMap(mapper);
  }

  void _onLoadVectorNote(LoadVectorNote event, Emitter<VectorEditorState> emit) {
    emit(VectorEditorLoaded(document: event.document));
  }

  void _onStartVectorStroke(StartVectorStroke event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newStroke = VectorStrokeElement(
      id: _uuid.v4(),
      position: Offset.zero, // Strokes are anchored at absolute zero coordinate space
      points: [event.position],
      pressures: [event.pressure],
      colorValue: 0xFF0F172A, // Dark slate primary color
      strokeWidth: 3.0,
    );

    emit(currentState.copyWith(currentStroke: newStroke));
  }

  void _onUpdateVectorStroke(UpdateVectorStroke event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final stroke = currentState.currentStroke;
    if (stroke == null) return;

    final updatedPoints = List<Offset>.from(stroke.points)..add(event.position);
    final updatedPressures = List<double>.from(stroke.pressures)..add(event.pressure);

    emit(currentState.copyWith(
      currentStroke: stroke.copyWith(
        points: updatedPoints,
        pressures: updatedPressures,
      ),
    ));
  }

  void _onEndStroke(EndVectorStroke event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final stroke = currentState.currentStroke;
    if (stroke == null) return;

    // Filter out tiny accidental taps to keep DB clean
    if (stroke.points.length < 2) {
      emit(currentState.copyWith(clearStroke: true));
      return;
    }

    final updatedElements = List<VectorElement>.from(currentState.document.elements)..add(stroke);
    final updatedDoc = currentState.document.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(
      document: updatedDoc,
      clearStroke: true,
    ));

    add(const SaveVectorNote());
  }

  void _onEraseAtPosition(EraseAtVectorPosition event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;
    final erasePos = event.position;

    final List<VectorElement> remainingElements = [];
    bool didErase = false;
    final eraserThreshold = 18.0; // Eraser brush radius

    for (final elem in doc.elements) {
      bool shouldDelete = false;

      if (elem is VectorStrokeElement) {
        // Precise vector stroke collision check
        for (final pt in elem.points) {
          if ((pt - erasePos).distance < eraserThreshold) {
            shouldDelete = true;
            didErase = true;
            break;
          }
        }
      } else if (elem is VectorTextElement) {
        // AABB check for text cards
        final rect = Rect.fromLTWH(
          elem.position.dx,
          elem.position.dy,
          elem.size.width,
          elem.size.height,
        );
        if (rect.contains(erasePos)) {
          shouldDelete = true;
          didErase = true;
        }
      } else if (elem is VectorPhotoElement) {
        // AABB check for photos
        final rect = Rect.fromLTWH(
          elem.position.dx,
          elem.position.dy,
          elem.size.width,
          elem.size.height,
        );
        if (rect.contains(erasePos)) {
          shouldDelete = true;
          didErase = true;
        }
      } else if (elem is VectorConnectorElement) {
        // Dynamic anchor eraser bypass: Connectors are automatically removed if their hosts die.
        // Or if eraser overlaps the connecting vector midpoint.
        final pSource = elem.sourceAnchor + erasePos; // Rough bounding check
        if ((elem.position - erasePos).distance < eraserThreshold) {
          shouldDelete = true;
          didErase = true;
        }
      }

      if (!shouldDelete) {
        remainingElements.add(elem);
      }
    }

    if (didErase) {
      // Cascade delete: Purge dangling connectors whose target or source nodes are missing
      final aliveNodeIds = remainingElements.map((e) => e.id).toSet();
      final cleanedElements = remainingElements.where((elem) {
        if (elem is VectorConnectorElement) {
          return aliveNodeIds.contains(elem.sourceId) && aliveNodeIds.contains(elem.targetId);
        }
        return true;
      }).toList();

      final updatedDoc = doc.copyWith(
        elements: cleanedElements,
        updatedAt: DateTime.now(),
      );

      emit(currentState.copyWith(
        document: updatedDoc,
        eraserPosition: erasePos,
      ));

      add(const SaveVectorNote());
    } else {
      emit(currentState.copyWith(eraserPosition: erasePos));
    }
  }

  void _onAddTextCard(AddTextCard event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newId = event.id ?? _uuid.v4();
    final newCard = VectorTextElement(
      id: newId,
      position: event.canvasPosition,
      text: '', // Empty text ready for initial cursor trigger
      size: const Size(200, 80),
      backgroundColorValue: 0xCCFFFFFF, // Glassmorphic white default
      textColorValue: 0xFF0F172A,
      fontSize: 16.0,
    );

    final updatedElements = List<VectorElement>.from(currentState.document.elements)..add(newCard);
    final updatedDoc = currentState.document.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(
      document: updatedDoc,
      selectedElementId: newId,
    ));

    add(const SaveVectorNote());
  }

  void _onUpdateTextCard(UpdateTextCard event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;

    final updatedElements = doc.elements.map((elem) {
      if (elem.id == event.id && elem is VectorTextElement) {
        return elem.copyWith(
          text: event.content,
          isBold: event.isBold,
          isItalic: event.isItalic,
          fontSize: event.fontSize,
          textColorValue: event.textColorValue,
        );
      }
      return elem;
    }).toList();

    final updatedDoc = doc.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(document: updatedDoc));
    add(const SaveVectorNote());
  }

  void _onMoveElement(MoveElement event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;

    final updatedElements = doc.elements.map((elem) {
      if (elem.id == event.id) {
        if (elem.isLocked) return elem; // Locked elements cannot be moved
        if (elem is VectorStrokeElement) {
          // Offsetting all points collectively
          final offsetDiff = event.newPosition - elem.position;
          final shiftedPoints = elem.points.map((p) => p + offsetDiff).toList();
          return elem.copyWith(position: event.newPosition, points: shiftedPoints);
        } else if (elem is VectorTextElement) {
          return elem.copyWith(position: event.newPosition);
        } else if (elem is VectorPhotoElement) {
          return elem.copyWith(position: event.newPosition);
        } else if (elem is VectorConnectorElement) {
          return elem.copyWith(position: event.newPosition);
        }
      }
      return elem;
    }).toList();

    final updatedDoc = doc.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(document: updatedDoc));
    add(const SaveVectorNote());
  }

  void _onAddPhotoNode(AddPhotoNode event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newId = _uuid.v4();
    final newPhoto = VectorPhotoElement(
      id: newId,
      position: event.canvasPosition,
      filePath: event.filePath,
      size: const Size(260, 180), // Standard aspect ratio default
    );

    final updatedElements = List<VectorElement>.from(currentState.document.elements)..add(newPhoto);
    final updatedDoc = currentState.document.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(
      document: updatedDoc,
      selectedElementId: newId,
    ));

    add(const SaveVectorNote());
  }

  void _onEstablishConnection(EstablishConnection event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newId = _uuid.v4();
    final newConnector = VectorConnectorElement(
      id: newId,
      position: Offset.zero,
      sourceId: event.sourceId,
      targetId: event.targetId,
      sourceAnchor: event.sourceAnchor,
      targetAnchor: event.targetAnchor,
      colorValue: 0xFF6366F1, // Premium violet/indigo connect theme
      strokeWidth: 2.0,
      isDashed: true,
    );

    final updatedElements = List<VectorElement>.from(currentState.document.elements)..add(newConnector);
    final updatedDoc = currentState.document.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(
      document: updatedDoc,
      clearConnectorSource: true,
    ));

    add(const SaveVectorNote());
  }

  void _onChangeTool(ChangeVectorTool event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    
    emit(currentState.copyWith(
      activeTool: event.tool,
      clearSelectedElement: event.tool != VectorTool.select,
      clearEraser: true,
      clearConnectorSource: true,
    ));
  }

  void _onSelectElement(SelectElement event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    emit(currentState.copyWith(
      selectedElementId: event.elementId,
      clearSelectedElement: event.elementId == null,
    ));
  }

  void _onDeleteElement(DeleteElement event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;

    // Filter target and its dependent connectors
    final remainingElements = doc.elements.where((e) => e.id != event.id).toList();
    final aliveNodeIds = remainingElements.map((e) => e.id).toSet();
    final cleanedElements = remainingElements.where((elem) {
      if (elem is VectorConnectorElement) {
        return aliveNodeIds.contains(elem.sourceId) && aliveNodeIds.contains(elem.targetId);
      }
      return true;
    }).toList();

    final updatedDoc = doc.copyWith(
      elements: cleanedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(
      document: updatedDoc,
      clearSelectedElement: currentState.selectedElementId == event.id,
    ));

    add(const SaveVectorNote());
  }

  void _onResizeElement(ResizeElement event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;

    final updatedElements = doc.elements.map((elem) {
      if (elem.id == event.id) {
        if (elem.isLocked) return elem; // Locked elements cannot be resized
        if (elem is VectorTextElement) {
          return elem.copyWith(size: event.newSize);
        } else if (elem is VectorPhotoElement) {
          return elem.copyWith(size: event.newSize);
        }
      }
      return elem;
    }).toList();

    final updatedDoc = doc.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(document: updatedDoc));
    add(const SaveVectorNote());
  }

  Future<void> _onSaveVectorNote(SaveVectorNote event, Emitter<VectorEditorState> emit) async {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    await _vectorNoteRepository.saveVectorNote(currentState.document);
    debugPrint('Vector Note Auto-Saved: ${currentState.document.id}');
  }

  void _onToggleLockElement(ToggleLockElement event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    final doc = currentState.document;

    final updatedElements = doc.elements.map((elem) {
      if (elem.id == event.id) {
        if (elem is VectorTextElement) {
          return elem.copyWith(isLocked: !elem.isLocked);
        } else if (elem is VectorPhotoElement) {
          return elem.copyWith(isLocked: !elem.isLocked);
        }
      }
      return elem;
    }).toList();

    final updatedDoc = doc.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(document: updatedDoc));
    add(const SaveVectorNote());
  }
}
