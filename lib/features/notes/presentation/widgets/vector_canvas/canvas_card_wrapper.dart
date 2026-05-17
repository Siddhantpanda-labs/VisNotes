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
              onTap: widget.isEditable ? widget.onTap : null,
              onDoubleTap: widget.isEditable ? widget.onDoubleTap : null,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(elem is VectorTextElement ? 16 : 20),
                  border: Border.all(
                    color: widget.isSelected && widget.isEditable
                        ? (elem.isLocked ? const Color(0xFFEF4444) : const Color(0xFF6366F1))
                        : Colors.transparent,
                    width: widget.isSelected && widget.isEditable ? 2.0 : 0.0,
                  ),
                ),
                child: widget.child,
              ),
            ),
          ),

          // A. Lock Toggle Button (Top-Right edge of card overlay, visible when card is selected and editable)
          if (widget.isSelected && widget.isEditable)
            Positioned(
              right: -10,
              top: -14,
              child: GestureDetector(
                onTap: () {
                  context.read<VectorEditorBloc>().add(ToggleLockElement(elem.id));
                },
                child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: elem.isLocked ? const Color(0xFFEF4444) : const Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: Icon(
                      elem.isLocked ? Icons.lock_rounded : Icons.lock_open_rounded,
                      color: Colors.white,
                      size: 14,
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
              top: -14,
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
                      width: 28,
                      height: 28,
                      decoration: const BoxDecoration(
                        color: Color(0xFF6366F1),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

          // C. Draggable Corner Resize Handle (Bottom-Right corner, visible when card is selected, editable, and NOT locked/editing)
          if (widget.isSelected && widget.isEditable && !widget.isEditing && !elem.isLocked)
            Positioned(
              right: -10,
              bottom: -10,
              child: GestureDetector(
                onPanStart: (details) {
                  widget.onResizeStateChanged(true); // Lock panning!
                  _startSize = size;
                },
                onPanUpdate: (details) {
                  final double newWidth = (_startSize.width + details.localPosition.dx).clamp(100.0, 1000.0);
                  final double newHeight = (_startSize.height + details.localPosition.dy).clamp(60.0, 1000.0);
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
                    width: 22,
                    height: 22,
                    decoration: const BoxDecoration(
                      color: Color(0xFF6366F1),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.open_in_full_rounded,
                        color: Colors.white,
                        size: 11,
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
