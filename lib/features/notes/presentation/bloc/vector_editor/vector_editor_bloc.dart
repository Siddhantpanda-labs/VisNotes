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
    on<ChangeActiveGroup>(_onChangeActiveGroup);
    on<AddCanvasGroup>(_onAddCanvasGroup);
    
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
      position: Offset.zero, // Strokes are anchored at local coordinate origin
      points: [event.position],
      pressures: [event.pressure],
      colorValue: 0xFF0F172A, // Dark slate primary color
      strokeWidth: 3.0,
      parentGroupId: currentState.activeGroupId,
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

    final updatedElements = _addElementToTree(
      currentState.document.elements,
      currentState.activeGroupId,
      stroke,
    );

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
    
    // Transform local event position inside the active group to root space
    final rootErasePos = _localToRoot(event.position, currentState.activeGroupId, doc.elements);
    final eraserThreshold = 18.0; // Eraser brush radius
    
    final eraseResult = _eraseInTree(doc.elements, rootErasePos, eraserThreshold);

    if (eraseResult.didErase) {
      // Cascade delete: Purge dangling connectors whose target or source nodes are missing
      final flatElements = _flattenTree(eraseResult.elements);
      final aliveNodeIds = flatElements.map((e) => e.id).toSet();
      
      List<VectorElement> cleanTree(List<VectorElement> tree) {
        final List<VectorElement> cleaned = [];
        for (final elem in tree) {
          if (elem is VectorConnectorElement) {
            if (aliveNodeIds.contains(elem.sourceId) && aliveNodeIds.contains(elem.targetId)) {
              cleaned.add(elem);
            }
          } else if (elem is VectorCanvasGroup) {
            cleaned.add(elem.copyWith(children: cleanTree(elem.children)));
          } else {
            cleaned.add(elem);
          }
        }
        return cleaned;
      }

      final cleanedElements = cleanTree(eraseResult.elements);

      final updatedDoc = doc.copyWith(
        elements: cleanedElements,
        updatedAt: DateTime.now(),
      );

      emit(currentState.copyWith(
        document: updatedDoc,
        eraserPosition: event.position,
      ));

      add(const SaveVectorNote());
    } else {
      emit(currentState.copyWith(eraserPosition: event.position));
    }
  }

  void _onAddTextCard(AddTextCard event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newId = event.id ?? _uuid.v4();
    final scale = event.scale > 0 ? event.scale : 1.0;
    final newCard = VectorTextElement(
      id: newId,
      position: event.canvasPosition,
      text: '', // Empty text ready for initial cursor trigger
      size: Size(200.0 / scale, 80.0 / scale),
      backgroundColorValue: 0xCCFFFFFF, // Glassmorphic white default
      textColorValue: 0xFF0F172A,
      fontSize: 16.0 / scale,
      scale: scale,
      parentGroupId: currentState.activeGroupId,
    );

    final updatedElements = _addElementToTree(
      currentState.document.elements,
      currentState.activeGroupId,
      newCard,
    );

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

    final updatedElements = _updateElementInTree(doc.elements, event.id, (elem) {
      if (elem is VectorTextElement) {
        return elem.copyWith(
          text: event.content,
          isBold: event.isBold,
          isItalic: event.isItalic,
          fontSize: event.fontSize,
          textColorValue: event.textColorValue,
        );
      }
      return elem;
    });

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

    final parent = _findParentGroupOf(event.id, doc.elements);
    final parentScale = parent != null ? _getElementAbsoluteScale(parent, doc.elements) : 1.0;
    
    final currentElem = _findElementById(event.id, doc.elements);
    if (currentElem == null) return;
    
    final currentAbsPos = _localToRoot(currentElem.position, currentElem.parentGroupId, doc.elements);
    final absDelta = event.newPosition - currentAbsPos;
    final localDelta = absDelta / parentScale;

    final updatedElements = _updateElementInTree(doc.elements, event.id, (elem) {
      if (elem.isLocked) return elem; // Locked elements cannot be moved
      final newLocalPos = elem.position + localDelta;
      if (elem is VectorStrokeElement) {
        final shiftedPoints = elem.points.map((p) => p + localDelta).toList();
        return elem.copyWith(position: newLocalPos, points: shiftedPoints);
      } else if (elem is VectorTextElement) {
        return elem.copyWith(position: newLocalPos);
      } else if (elem is VectorPhotoElement) {
        return elem.copyWith(position: newLocalPos);
      } else if (elem is VectorCanvasGroup) {
        return elem.copyWith(position: newLocalPos);
      } else if (elem is VectorConnectorElement) {
        return elem.copyWith(position: newLocalPos);
      }
      return elem;
    });

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
    final scale = event.scale > 0 ? event.scale : 1.0;
    final newPhoto = VectorPhotoElement(
      id: newId,
      position: event.canvasPosition,
      filePath: event.filePath,
      size: Size(260.0 / scale, 180.0 / scale), // Standard aspect ratio default
      scale: scale,
      parentGroupId: currentState.activeGroupId,
    );

    final updatedElements = _addElementToTree(
      currentState.document.elements,
      currentState.activeGroupId,
      newPhoto,
    );

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
      parentGroupId: currentState.activeGroupId,
    );

    final updatedElements = _addElementToTree(
      currentState.document.elements,
      currentState.activeGroupId,
      newConnector,
    );

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
    final remainingElements = _removeElementFromTree(doc.elements, event.id);
    final flatElements = _flattenTree(remainingElements);
    final aliveNodeIds = flatElements.map((e) => e.id).toSet();
    
    List<VectorElement> cleanTree(List<VectorElement> tree) {
      final List<VectorElement> cleaned = [];
      for (final elem in tree) {
        if (elem is VectorConnectorElement) {
          if (aliveNodeIds.contains(elem.sourceId) && aliveNodeIds.contains(elem.targetId)) {
            cleaned.add(elem);
          }
        } else if (elem is VectorCanvasGroup) {
          cleaned.add(elem.copyWith(children: cleanTree(elem.children)));
        } else {
          cleaned.add(elem);
        }
      }
      return cleaned;
    }

    final cleanedElements = cleanTree(remainingElements);

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

    final parent = _findParentGroupOf(event.id, doc.elements);
    final parentScale = parent != null ? _getElementAbsoluteScale(parent, doc.elements) : 1.0;
    final localSize = event.newSize / parentScale;

    final updatedElements = _updateElementInTree(doc.elements, event.id, (elem) {
      if (elem.isLocked) return elem; // Locked elements cannot be resized
      if (elem is VectorTextElement) {
        return elem.copyWith(size: localSize);
      } else if (elem is VectorPhotoElement) {
        return elem.copyWith(size: localSize);
      } else if (elem is VectorCanvasGroup) {
        return elem.copyWith(size: localSize);
      }
      return elem;
    });

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

    final updatedElements = _updateElementInTree(doc.elements, event.id, (elem) {
      if (elem is VectorTextElement) {
        return elem.copyWith(isLocked: !elem.isLocked);
      } else if (elem is VectorPhotoElement) {
        return elem.copyWith(isLocked: !elem.isLocked);
      } else if (elem is VectorCanvasGroup) {
        return elem.copyWith(isLocked: !elem.isLocked);
      }
      return elem;
    });

    final updatedDoc = doc.copyWith(
      elements: updatedElements,
      updatedAt: DateTime.now(),
    );

    emit(currentState.copyWith(document: updatedDoc));
    add(const SaveVectorNote());
  }

  void _onChangeActiveGroup(ChangeActiveGroup event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;
    emit(currentState.copyWith(
      activeGroupId: event.activeGroupId,
      clearActiveGroup: event.activeGroupId == null,
    ));
  }

  void _onAddCanvasGroup(AddCanvasGroup event, Emitter<VectorEditorState> emit) {
    if (state is! VectorEditorLoaded) return;
    final currentState = state as VectorEditorLoaded;

    final newId = event.id ?? _uuid.v4();
    final scale = event.scale > 0 ? event.scale : 1.0;
    final newGroup = VectorCanvasGroup(
      id: newId,
      position: event.canvasPosition,
      size: Size(800.0 / scale, 600.0 / scale), // Default canvas bounds
      children: const [],
      parentGroupId: currentState.activeGroupId,
    );

    final updatedElements = _addElementToTree(
      currentState.document.elements,
      currentState.activeGroupId,
      newGroup,
    );

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

  // ── Hierarchical Nesting Helpers ───────────────────────────────────────────

  List<VectorElement> _addElementToTree(
    List<VectorElement> tree,
    String? targetGroupId,
    VectorElement newElem,
  ) {
    if (targetGroupId == null) {
      return List<VectorElement>.from(tree)..add(newElem.copyWith(parentGroupId: null));
    }

    return tree.map((elem) {
      if (elem.id == targetGroupId && elem is VectorCanvasGroup) {
        final updatedChildren = List<VectorElement>.from(elem.children)
          ..add(newElem.copyWith(parentGroupId: targetGroupId));
        return elem.copyWith(children: updatedChildren);
      } else if (elem is VectorCanvasGroup) {
        return elem.copyWith(children: _addElementToTree(elem.children, targetGroupId, newElem));
      }
      return elem;
    }).toList();
  }

  List<VectorElement> _updateElementInTree(
    List<VectorElement> tree,
    String targetId,
    VectorElement Function(VectorElement) updater,
  ) {
    return tree.map((elem) {
      if (elem.id == targetId) {
        return updater(elem);
      } else if (elem is VectorCanvasGroup) {
        return elem.copyWith(children: _updateElementInTree(elem.children, targetId, updater));
      }
      return elem;
    }).toList();
  }

  List<VectorElement> _removeElementFromTree(
    List<VectorElement> tree,
    String targetId,
  ) {
    final List<VectorElement> updated = [];
    for (final elem in tree) {
      if (elem.id == targetId) {
        continue; // Skip/Remove this element
      }
      if (elem is VectorCanvasGroup) {
        updated.add(elem.copyWith(children: _removeElementFromTree(elem.children, targetId)));
      } else {
        updated.add(elem);
      }
    }
    return updated;
  }

  Offset _localToRoot(Offset localPos, String? startGroupId, List<VectorElement> elements) {
    if (startGroupId == null) return localPos;

    final parentGroup = _findParentGroupOf(startGroupId, elements);
    final group = _findElementById(startGroupId, elements);

    if (group == null) return localPos;

    // Convert local position inside group to parent's coordinate space
    final parentPos = group.position + localPos * group.scale;

    if (parentGroup == null) {
      return parentPos;
    }

    return _localToRoot(parentPos, parentGroup.id, elements);
  }

  VectorCanvasGroup? _findParentGroupOf(String id, List<VectorElement> tree) {
    for (final elem in tree) {
      if (elem is VectorCanvasGroup) {
        if (elem.children.any((child) => child.id == id)) {
          return elem;
        }
        final found = _findParentGroupOf(id, elem.children);
        if (found != null) return found;
      }
    }
    return null;
  }

  VectorElement? _findElementById(String id, List<VectorElement> tree) {
    for (final elem in tree) {
      if (elem.id == id) {
        return elem;
      }
      if (elem is VectorCanvasGroup) {
        final found = _findElementById(id, elem.children);
        if (found != null) return found;
      }
    }
    return null;
  }

  List<VectorElement> _flattenTree(List<VectorElement> tree) {
    final List<VectorElement> flat = [];
    for (final elem in tree) {
      flat.add(elem);
      if (elem is VectorCanvasGroup) {
        flat.addAll(_flattenTree(elem.children));
      }
    }
    return flat;
  }

  EraseResult _eraseInTree(
    List<VectorElement> tree,
    Offset localErasePos,
    double eraserThreshold,
  ) {
    final List<VectorElement> remaining = [];
    bool didErase = false;

    for (final elem in tree) {
      bool shouldDelete = false;

      if (elem is VectorStrokeElement) {
        for (final pt in elem.points) {
          if ((pt - localErasePos).distance < eraserThreshold) {
            shouldDelete = true;
            didErase = true;
            break;
          }
        }
      } else if (elem is VectorTextElement) {
        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
        if (rect.contains(localErasePos)) {
          shouldDelete = true;
          didErase = true;
        }
      } else if (elem is VectorPhotoElement) {
        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
        if (rect.contains(localErasePos)) {
          shouldDelete = true;
          didErase = true;
        }
      } else if (elem is VectorCanvasGroup) {
        final childErasePos = (localErasePos - elem.position) / elem.scale;
        final childResult = _eraseInTree(elem.children, childErasePos, eraserThreshold / elem.scale);
        if (childResult.didErase) {
          didErase = true;
          remaining.add(elem.copyWith(children: childResult.elements));
        } else {
          remaining.add(elem);
        }
        continue;
      } else if (elem is VectorConnectorElement) {
        if ((elem.position - localErasePos).distance < eraserThreshold) {
          shouldDelete = true;
          didErase = true;
        }
      }

      if (!shouldDelete) {
        remaining.add(elem);
      }
    }

    return EraseResult(remaining, didErase);
  }

  double _getElementAbsoluteScale(VectorElement elem, List<VectorElement> tree) {
    if (elem.parentGroupId == null) return elem.scale;
    final parent = _findParentGroupOf(elem.parentGroupId!, tree);
    if (parent == null) return elem.scale;
    return _getElementAbsoluteScale(parent, tree) * elem.scale;
  }
}

class EraseResult {
  final List<VectorElement> elements;
  final bool didErase;

  EraseResult(this.elements, this.didErase);
}
