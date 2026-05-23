import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/vector_editor/vector_editor_bloc.dart';
import '../../bloc/vector_editor/vector_editor_event.dart';
import 'package:visnotes/features/notes/domain/entities/vector_canvas/vector_element.dart';

class CanvasCardWrapper extends StatefulWidget {
  final VectorElement element;
  final bool isSelected;
  final bool isEditing;
  final Widget child;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;
  final ValueChanged<bool> onResizeStateChanged; // Notify parent when drag starts/ends to lock pan!
  final bool isEditable; // Secure interaction mode flag
  final double scale; // Viewport scale to keep handles constant visual size

  const CanvasCardWrapper({
    super.key,
    required this.element,
    required this.isSelected,
    required this.isEditing,
    required this.child,
    required this.onTap,
    required this.onDoubleTap,
    required this.onResizeStateChanged,
    required this.isEditable,
    required this.scale,
  });

  @override
  State<CanvasCardWrapper> createState() => _CanvasCardWrapperState();
}

class _CanvasCardWrapperState extends State<CanvasCardWrapper> {
  late Size _startSize;

  @override
  Widget build(BuildContext context) {
    final elem = widget.element;
    final Size size = elem is VectorTextElement ? elem.size : (elem as VectorPhotoElement).size;
    final double scale = widget.scale > 0 ? widget.scale : 1.0;

    return Positioned(
      left: elem.position.dx,
      top: elem.position.dy,
      width: size.width,
      height: size.height,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Body GestureDetector handles selections/double-taps in Edit mode
          Positioned.fill(
            child: GestureDetector(
              onTap: (widget.isEditable && !widget.isEditing) ? widget.onTap : null,
              onDoubleTap: (widget.isEditable && !widget.isEditing) ? widget.onDoubleTap : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(elem is VectorTextElement ? 16 : 20),
                  border: Border.all(
                    color: widget.isSelected && widget.isEditable
                        ? (elem.isLocked ? const Color(0xFFEF4444) : const Color(0xFF6366F1))
                        : Colors.transparent,
                    width: widget.isSelected && widget.isEditable ? 2.0 / scale : 0.0,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),

          // A. Lock Toggle Button (Top-Right edge of card overlay, visible when card is selected and editable)
          if (widget.isSelected && widget.isEditable)
            Positioned(
              right: -10.0 / scale,
              top: -14.0 / scale,
              child: GestureDetector(
                onTap: () {
                  context.read<VectorEditorBloc>().add(ToggleLockElement(elem.id));
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 28.0 / scale,
                    height: 28.0 / scale,
                    decoration: BoxDecoration(
                      color: elem.isLocked ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0 / scale,
                          offset: Offset(0, 2.0 / scale),
                        )
                      ],
                    ),
                    child: Icon(
                      elem.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 14.0 / scale,
                    ),
                  ),
                ),
              ),
            ),

          // B. Move Anchor Plus Icon (Top-Middle edge of card overlay, visible only when card is selected, editable, and NOT locked)
          if (widget.isSelected && widget.isEditable && !elem.isLocked)
            Positioned(
              left: 0,
              right: 0,
              top: -14.0 / scale,
              child: Center(
                child: GestureDetector(
                  onPanStart: (_) {
                    widget.onResizeStateChanged(true); // Lock panning!
                  },
                  onPanUpdate: (details) {
                    final Offset newPos = elem.position + details.delta;
                    context.read<VectorEditorBloc>().add(MoveElement(elem.id, newPos));
                  },
                  onPanEnd: (_) {
                    widget.onResizeStateChanged(false); // Unlock panning!
                  },
                  onPanCancel: () {
                    widget.onResizeStateChanged(false); // Unlock panning!
                  },
                  child: MouseRegion(
                    cursor: SystemMouseCursors.move,
                    child: Container(
                      width: 28.0 / scale,
                      height: 28.0 / scale,
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4.0 / scale,
                            offset: Offset(0, 2.0 / scale),
                          )
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16.0 / scale,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // C. Draggable Corner Resize Handle (Bottom-Right corner, visible when card is selected, editable, and NOT locked)
          if (widget.isSelected && widget.isEditable && !elem.isLocked)
            Positioned(
              right: -10.0 / scale,
              bottom: -10.0 / scale,
              child: GestureDetector(
                onPanStart: (details) {
                  widget.onResizeStateChanged(true); // Lock panning!
                  _startSize = size;
                },
                onPanUpdate: (details) {
                  final double elementScale = elem.scale > 0 ? elem.scale : 1.0;
                  final double minWidth = 100.0 / elementScale;
                  final double maxWidth = 1000.0 / elementScale;
                  final double minHeight = 60.0 / elementScale;
                  final double maxHeight = 1000.0 / elementScale;

                  final double newWidth = (_startSize.width + details.localPosition.dx).clamp(minWidth, maxWidth);
                  final double newHeight = (_startSize.height + details.localPosition.dy).clamp(minHeight, maxHeight);
                  context.read<VectorEditorBloc>().add(
                        ResizeElement(elem.id, Size(newWidth, newHeight)),
                      );
                },
                onPanEnd: (_) {
                  widget.onResizeStateChanged(false); // Unlock panning!
                },
                onPanCancel: () {
                  widget.onResizeStateChanged(false); // Unlock panning!
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.resizeUpLeftDownRight,
                  child: Container(
                    width: 22.0 / scale,
                    height: 22.0 / scale,
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4.0 / scale,
                          offset: Offset(0, 2.0 / scale),
                        )
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        Icons.open_in_full_rounded,
                        color: Colors.white,
                        size: 11.0 / scale,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
