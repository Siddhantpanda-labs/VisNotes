import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:file_picker/file_picker.dart';

import '../../bloc/vector_editor/vector_editor_bloc.dart';
import '../../bloc/vector_editor/vector_editor_event.dart';
import '../../bloc/vector_editor/vector_editor_state.dart';
import '../../../domain/entities/vector_canvas/vector_element.dart';
import 'vector_canvas_painter.dart';
import 'canvas_card_wrapper.dart';
import 'canvas_text_card.dart';
import 'canvas_photo_card.dart';

class VectorCanvasWidget extends StatefulWidget {
  const VectorCanvasWidget({super.key});

  @override
  State<VectorCanvasWidget> createState() => _VectorCanvasWidgetState();
}

class _VectorCanvasWidgetState extends State<VectorCanvasWidget> {
  final TransformationController _transformationController = TransformationController();
  final double _canvasWidth = 30000.0;
  final double _canvasHeight = 20000.0;
  double _zoomPercentage = 100.0;

  // Track the text controller mapped by element ID
  final Map<String, TextEditingController> _textControllers = {};
  String? _editingElementId;
  bool _isResizingOrEditingCard = false; // Lock panning/scaling while interacting with cards!

  @override
  void initState() {
    super.initState();
    // Center the viewport at the middle of our vast canvas
    final double initialX = (_canvasWidth / 2) - 400; // Offset by half a standard screen
    final double initialY = (_canvasHeight / 2) - 300;
    _transformationController.value = Matrix4.identity()
      ..translate(-initialX, -initialY);

    _transformationController.addListener(_onTransformationChanged);
  }

  @override
  void dispose() {
    _transformationController.removeListener(_onTransformationChanged);
    _transformationController.dispose();
    for (var controller in _textControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onTransformationChanged() {
    final double scale = _transformationController.value.getMaxScaleOnAxis();
    setState(() {
      _zoomPercentage = scale * 100.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VectorEditorBloc, VectorEditorState>(
      builder: (context, state) {
        if (state is! VectorEditorLoaded) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF6366F1)),
          );
        }

        final doc = state.document;
        final elements = doc.elements;
        final isDrawingOrErasing = state.activeTool == VectorTool.pen ||
            state.activeTool == VectorTool.eraser ||
            state.activeTool == VectorTool.connector;

        return Stack(
          children: [
            // 1. The Zoomable Infinite Viewport
            InteractiveViewer(
              transformationController: _transformationController,
              boundaryMargin: EdgeInsets.zero, // Prevent camera from moving beyond canvas borders!
              constrained: false, // Ensures child Container retains its massive bounds!
              minScale: 0.1, // Zoom out to 10%
              maxScale: 10.0, // Infinite zoom depth (up to 1000%)
              panEnabled: !isDrawingOrErasing && !_isResizingOrEditingCard, // Lock pan during card resizing/drawing
              scaleEnabled: !isDrawingOrErasing && !_isResizingOrEditingCard, // Lock zoom during card resizing/drawing
              child: Container(
                width: _canvasWidth,
                height: _canvasHeight,
                color: const Color(0xFFF8FAFC), // sleek subtle slate background
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    // A. Vector Canvas Custom Painter (Dot grid + ink strokes + connectors)
                    Positioned.fill(
                      child: GestureDetector(
                        onSecondaryTapUp: (details) {
                          if (state.activeTool == VectorTool.select) {
                            _handleRightClick(context, details.globalPosition, state);
                          }
                        },
                        onLongPressStart: (details) {
                          if (state.activeTool == VectorTool.select) {
                            _handleRightClick(context, details.globalPosition, state);
                          }
                        },
                        child: Listener(
                          onPointerDown: (e) => _onPointerDown(context, e, state),
                          onPointerMove: (e) => _onPointerMove(context, e, state),
                          onPointerUp: (e) => _onPointerUp(context, e, state),
                          child: CustomPaint(
                            size: Size(_canvasWidth, _canvasHeight),
                            painter: VectorCanvasPainter(
                              elements: elements,
                              scale: _transformationController.value.getMaxScaleOnAxis(),
                              currentStroke: state.currentStroke,
                              selectedElementId: state.selectedElementId,
                            ),
                          ),
                        ),
                      ),
                    ),

                    // B. Interactive Cards (Floating text cards, Photo nodes wrapped in unified draggable wrappers)
                    ...elements.map((elem) {
                      final isSelected = state.selectedElementId == elem.id;
                      final isEditing = _editingElementId == elem.id;

                      if (elem is VectorTextElement) {
                        if (!_textControllers.containsKey(elem.id)) {
                          _textControllers[elem.id] = TextEditingController(text: elem.text);
                        }
                        final controller = _textControllers[elem.id]!;

                        return CanvasCardWrapper(
                          element: elem,
                          isSelected: isSelected,
                          isEditing: isEditing,
                          isEditable: state.activeTool == VectorTool.select,
                          scale: _transformationController.value.getMaxScaleOnAxis(),
                          onResizeStateChanged: (val) {
                            setState(() {
                              _isResizingOrEditingCard = val;
                            });
                          },
                          onTap: () {
                            if (state.activeTool == VectorTool.select) {
                              context.read<VectorEditorBloc>().add(SelectElement(elem.id));
                            }
                          },
                          onDoubleTap: () {
                            if (state.activeTool == VectorTool.select) {
                              setState(() {
                                _editingElementId = elem.id;
                                _isResizingOrEditingCard = true; // Lock pan during typing focus
                              });
                            }
                          },
                          child: CanvasTextCard(
                            elem: elem,
                            isEditing: isEditing,
                            controller: controller,
                            onChanged: (val) {
                              context.read<VectorEditorBloc>().add(
                                    UpdateTextCard(id: elem.id, content: val),
                                  );
                            },
                            onSubmitted: () {
                              setState(() {
                                _editingElementId = null;
                                _isResizingOrEditingCard = false; // Unlock pan
                              });
                            },
                          ),
                        );
                      } else if (elem is VectorPhotoElement) {
                        return CanvasCardWrapper(
                          element: elem,
                          isSelected: isSelected,
                          isEditing: false,
                          isEditable: state.activeTool == VectorTool.select,
                          scale: _transformationController.value.getMaxScaleOnAxis(),
                          onResizeStateChanged: (val) {
                            setState(() {
                              _isResizingOrEditingCard = val;
                            });
                          },
                          onTap: () {
                            if (state.activeTool == VectorTool.select) {
                              context.read<VectorEditorBloc>().add(SelectElement(elem.id));
                            }
                          },
                          onDoubleTap: () {},
                          child: CanvasPhotoCard(elem: elem),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
            ),

            // 2. Interactive Zoom Indicator Badge (Top Right Closer to Middle)
            Positioned(
              top: 96,
              right: 24,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.85),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.black.withOpacity(0.08)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Text(
                  '${_zoomPercentage.toInt()}%',
                  style: GoogleFonts.outfit(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
            ),

            // 3. Dynamic Tooltip / Context Pill directly above selected element (Top Center projection)
            if (state.selectedElementId != null)
              _buildFloatingContextTooltip(context, state),
          ],
        );
      },
    );
  }

  // Pointer drawing events
  void _onPointerDown(BuildContext context, PointerDownEvent e, VectorEditorLoaded state) {
    final Offset scenePos = _transformationController.toScene(e.localPosition);

    if (state.activeTool == VectorTool.pen) {
      context.read<VectorEditorBloc>().add(
            StartVectorStroke(position: scenePos, pressure: e.pressure),
          );
    } else if (state.activeTool == VectorTool.text) {
      final generatedId = const Uuid().v4();
      final scale = _transformationController.value.getMaxScaleOnAxis();
      context.read<VectorEditorBloc>().add(AddTextCard(scenePos, scale: scale, id: generatedId));
      context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.select));
      setState(() {
        _editingElementId = generatedId;
        _isResizingOrEditingCard = true; // Lock pan during initial typing focus
      });
    } else if (state.activeTool == VectorTool.eraser) {
      context.read<VectorEditorBloc>().add(EraseAtVectorPosition(scenePos));
    } else if (state.activeTool == VectorTool.connector) {
      // Check if clicked inside a node to initiate rubber-band connect
      final clickedNode = _getNodeAtPosition(scenePos, state.document.elements);
      if (clickedNode != null) {
        context.read<VectorEditorBloc>().add(ChangeVectorTool(VectorTool.select)); // Reset
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Source: ${clickedNode.id.substring(0, 4)} selected. Tap another element to connect!'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else if (state.activeTool == VectorTool.select) {
      // Clear selection if tapping blank canvas area
      final clickedNode = _getNodeAtPosition(scenePos, state.document.elements);
      if (clickedNode == null) {
        context.read<VectorEditorBloc>().add(const SelectElement(null));
        setState(() {
          _editingElementId = null;
          _isResizingOrEditingCard = false; // Unlock panning
        });
      } else {
        context.read<VectorEditorBloc>().add(SelectElement(clickedNode.id));
      }
    }
  }

  void _onPointerMove(BuildContext context, PointerMoveEvent e, VectorEditorLoaded state) {
    final Offset scenePos = _transformationController.toScene(e.localPosition);

    if (state.activeTool == VectorTool.pen) {
      context.read<VectorEditorBloc>().add(
            UpdateVectorStroke(position: scenePos, pressure: e.pressure),
          );
    } else if (state.activeTool == VectorTool.eraser) {
      context.read<VectorEditorBloc>().add(EraseAtVectorPosition(scenePos));
    }
  }

  void _onPointerUp(BuildContext context, PointerUpEvent e, VectorEditorLoaded state) {
    if (state.activeTool == VectorTool.pen) {
      context.read<VectorEditorBloc>().add(const EndVectorStroke());
    }
  }

  VectorElement? _getNodeAtPosition(Offset pos, List<VectorElement> elements) {
    for (final elem in elements.reversed) {
      if (elem is VectorTextElement) {
        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
        if (rect.contains(pos)) return elem;
      } else if (elem is VectorPhotoElement) {
        final rect = Rect.fromLTWH(elem.position.dx, elem.position.dy, elem.size.width, elem.size.height);
        if (rect.contains(pos)) return elem;
      }
    }
    return null;
  }

  // Floating Context Tooltip projection directly above selected node
  Widget _buildFloatingContextTooltip(BuildContext context, VectorEditorLoaded state) {
    final selectedId = state.selectedElementId!;
    final elem = state.document.elements.firstWhere((e) => e.id == selectedId,
        orElse: () => const VectorStrokeElement(
              id: '',
              position: Offset.zero,
              points: [],
              pressures: [],
              colorValue: 0,
              strokeWidth: 0,
            ));

    if (elem.id.isEmpty) return const SizedBox.shrink();

    // Map canvas coordinates to viewport screen space coordinates
    final Offset canvasAnchor = elem.position;
    final Offset screenAnchor = MatrixUtils.transformPoint(_transformationController.value, canvasAnchor);

    return Positioned(
      left: screenAnchor.dx - 100, // Offset horizontally to center tooltip
      top: screenAnchor.dy - 68, // Display floating 68px directly above element
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF0F172A), // Premium obsidian dark color
          borderRadius: BorderRadius.circular(40),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (elem is VectorTextElement) ...[
              // A. Toggle Bold Text
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.format_bold_rounded,
                  color: elem.isBold ? const Color(0xFF818CF8) : Colors.white70,
                  size: 18,
                ),
                onPressed: () {
                  context.read<VectorEditorBloc>().add(
                        UpdateTextCard(id: elem.id, content: elem.text, isBold: !elem.isBold),
                      );
                },
              ),
              const SizedBox(width: 8),

              // B. Toggle Italic Text
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: Icon(
                  Icons.format_italic_rounded,
                  color: elem.isItalic ? const Color(0xFF818CF8) : Colors.white70,
                  size: 18,
                ),
                onPressed: () {
                  context.read<VectorEditorBloc>().add(
                        UpdateTextCard(id: elem.id, content: elem.text, isItalic: !elem.isItalic),
                      );
                },
              ),
              const SizedBox(width: 8),

              // C. Text card color palette selectors
              _buildColorSelector(context, elem, 0xFF0F172A), // Dark slate text
              const SizedBox(width: 4),
              _buildColorSelector(context, elem, 0xFFEF4444), // Coral Red
              const SizedBox(width: 4),
              _buildColorSelector(context, elem, 0xFF10B981), // Emerald Green
              const SizedBox(width: 4),
              _buildColorSelector(context, elem, 0xFF3B82F6), // Ocean Blue

              const VerticalDivider(color: Colors.white24, thickness: 1.0, width: 16),
            ],

            // D. Connect Link creator anchor trigger
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.link_rounded, color: Colors.white70, size: 18),
              onPressed: () {
                context.read<VectorEditorBloc>().add(const ChangeVectorTool(VectorTool.connector));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Click target node to connect connection anchor!')),
                );
              },
            ),
            const SizedBox(width: 8),

            // E. Delete Element Action
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              icon: const Icon(Icons.delete_rounded, color: Color(0xFFF87171), size: 18),
              onPressed: () {
                context.read<VectorEditorBloc>().add(DeleteElement(elem.id));
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildColorSelector(BuildContext context, VectorTextElement elem, int colorValue) {
    final bool isSelected = elem.textColorValue == colorValue;
    return GestureDetector(
      onTap: () {
        context.read<VectorEditorBloc>().add(
              UpdateTextCard(id: elem.id, content: elem.text, textColorValue: colorValue),
            );
      },
      child: Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: Color(colorValue),
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.white : Colors.white24,
            width: isSelected ? 2.0 : 1.0,
          ),
        ),
      ),
    );
  }

  void _handleRightClick(BuildContext context, Offset globalPosition, VectorEditorLoaded state) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final Offset localPos = renderBox.globalToLocal(globalPosition);
    final Offset scenePos = _transformationController.toScene(localPos);

    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        globalPosition.dx,
        globalPosition.dy,
        globalPosition.dx + 1,
        globalPosition.dy + 1,
      ),
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white.withOpacity(0.96),
      items: [
        PopupMenuItem<String>(
          value: 'text',
          child: Row(
            children: [
              const Icon(Icons.text_fields_rounded, color: Color(0xFF6366F1), size: 20),
              const SizedBox(width: 12),
              Text(
                'Add Textbox',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem<String>(
          value: 'photo',
          child: Row(
            children: [
              const Icon(Icons.image_rounded, color: Color(0xFF10B981), size: 20),
              const SizedBox(width: 12),
              Text(
                'Add Image',
                style: GoogleFonts.outfit(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
        ),
      ],
    ).then((value) {
      if (value == 'text') {
        _spawnTextboxAt(context, scenePos);
      } else if (value == 'photo') {
        _pickAndAddPhotoAt(context, scenePos);
      }
    });
  }

  void _spawnTextboxAt(BuildContext context, Offset scenePos) {
    final generatedId = const Uuid().v4();
    final scale = _transformationController.value.getMaxScaleOnAxis();
    context.read<VectorEditorBloc>().add(AddTextCard(scenePos, scale: scale, id: generatedId));
    setState(() {
      _editingElementId = generatedId;
      _isResizingOrEditingCard = true; // Lock pan during initial typing focus
    });
  }

  Future<void> _pickAndAddPhotoAt(BuildContext context, Offset scenePos) async {
    final bloc = context.read<VectorEditorBloc>();
    final messenger = ScaffoldMessenger.of(context);

    final result = await FilePicker.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.single.path != null) {
      final path = result.files.single.path!;
      final scale = _transformationController.value.getMaxScaleOnAxis();
      bloc.add(
        AddPhotoNode(
          canvasPosition: scenePos,
          filePath: path,
          scale: scale,
        ),
      );
      messenger.showSnackBar(
        const SnackBar(content: Text('Photo added to canvas!')),
      );
    }
  }
}
