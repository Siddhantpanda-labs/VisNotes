import 'package:flutter/material.dart';
import '../bloc/editor/note_editor_bloc_state.dart';

class FormattingToolbar extends StatelessWidget {
  final EditorTool activeTool;
  final Function(EditorTool) onToolChanged;
  final VoidCallback onBoldToggle;
  final VoidCallback onItalicToggle;
  final VoidCallback onHeadingToggle;
  final bool isBold;
  final bool isItalic;
  final bool isHeading;

  const FormattingToolbar({
    super.key,
    required this.activeTool,
    required this.onToolChanged,
    required this.onBoldToggle,
    required this.onItalicToggle,
    required this.onHeadingToggle,
    this.isBold = false,
    this.isItalic = false,
    this.isHeading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 8,
      borderRadius: BorderRadius.circular(30),
      color: Colors.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Tool Selection
            _ToolButton(
              icon: Icons.keyboard,
              isSelected: activeTool == EditorTool.select,
              onPressed: () => onToolChanged(EditorTool.select),
              label: 'Text',
            ),
            _ToolButton(
              icon: Icons.edit,
              isSelected: activeTool == EditorTool.pen,
              onPressed: () => onToolChanged(EditorTool.pen),
              label: 'Pen',
            ),
            _ToolButton(
              icon: Icons.auto_fix_high,
              customIcon: _PhysicalEraserIcon(isSelected: activeTool == EditorTool.eraser),
              isSelected: activeTool == EditorTool.eraser,
              onPressed: () => onToolChanged(EditorTool.eraser),
              label: 'Eraser',
            ),
            const VerticalDivider(width: 32),
            // Formatting - Using specialized _FormatButton to prevent focus loss
            _FormatButton(
              icon: Icons.format_bold,
              isActive: isBold,
              onPressed: onBoldToggle,
            ),
            _FormatButton(
              icon: Icons.format_italic,
              isActive: isItalic,
              onPressed: onItalicToggle,
            ),
            _FormatButton(
              icon: Icons.format_size,
              isActive: isHeading,
              onPressed: onHeadingToggle,
            ),
          ],
        ),
      ),
    );
  }
}

class _FormatButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _FormatButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: onPressed,
      color: isActive ? Colors.blue : Colors.black87,
      // CRITICAL: Prevent the button from taking focus
      focusNode: FocusNode(skipTraversal: true, canRequestFocus: false),
    );
  }
}

class _PhysicalEraserIcon extends StatelessWidget {
  final bool isSelected;
  const _PhysicalEraserIcon({required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.rotate(
        angle: -0.5,
        child: Container(
          width: 20,
          height: 12,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.black54,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB7C5), // Eraser Pink
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(1),
                      bottomLeft: Radius.circular(1),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(1),
                      bottomRight: Radius.circular(1),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ToolButton extends StatelessWidget {
  final IconData icon;
  final Widget? customIcon;
  final bool isSelected;
  final VoidCallback onPressed;
  final String label;

  const _ToolButton({
    required this.icon,
    this.customIcon,
    required this.isSelected,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: customIcon ?? Icon(icon),
            onPressed: onPressed,
            color: isSelected ? Colors.blue : Colors.black54,
            style: IconButton.styleFrom(
              backgroundColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
            ),
            // CRITICAL: Prevent the button from taking focus
            focusNode: FocusNode(skipTraversal: true, canRequestFocus: false),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: isSelected ? Colors.blue : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
