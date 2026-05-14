import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/note_block.dart';
import '../bloc/editor/note_editor_bloc.dart';
import '../bloc/editor/note_editor_bloc_state.dart';

/// Shows a compact dark context menu at [globalPosition].
/// Items adapt automatically to whether text is selected:
///   - No selection : Select All | Paste
///   - With selection: Select All | Cut | Copy | Paste
Future<void> showNoteContextMenu({
  required BuildContext context,
  required Offset globalPosition,
  required TextBlock textBlock,
  required TextSelection? selection,
  required int pageIndex,
}) async {
  final bloc = context.read<NoteEditorBloc>(); // capture before any await
  final hasSelection = selection != null && !selection.isCollapsed;
  final text = textBlock.content.plainText;

  final entries = <(String, String)>[
    ('select_all', 'Select All'),
    if (hasSelection) ...[ ('cut', 'Cut'), ('copy', 'Copy') ],
    ('paste', 'Paste'),
  ];

  const bg       = Color(0xFF2C2C2E);
  const fg       = Color(0xFFEEEEEE);
  const divColor = Color(0xFF3A3A3C);
  const itemH    = 30.0;

  // Divider is placed:
  //   - before 'cut' (index 1 when hasSelection)
  //   - before 'paste' (last item always)
  bool _needsDividerBefore(int i) {
    if (hasSelection && i == 1) return true;           // before Cut
    if (i == entries.length - 1) return true;          // before Paste
    return false;
  }

  final result = await showDialog<String>(
    context: context,
    barrierColor: Colors.transparent,
    barrierDismissible: true,
    builder: (dialogCtx) => Stack(
      children: [
        Positioned(
          left: globalPosition.dx,
          top: globalPosition.dy,
          child: Material(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(7),
                boxShadow: const [
                  BoxShadow(color: Colors.black38, blurRadius: 8, offset: Offset(0, 3)),
                ],
              ),
              child: IntrinsicWidth(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (int i = 0; i < entries.length; i++) ...[
                      if (_needsDividerBefore(i))
                        const Divider(height: 1, thickness: 1, color: divColor),
                      InkWell(
                        onTap: () => Navigator.of(dialogCtx, rootNavigator: true)
                            .pop(entries[i].$1),
                        borderRadius: BorderRadius.vertical(
                          top: i == 0 ? const Radius.circular(7) : Radius.zero,
                          bottom: i == entries.length - 1
                              ? const Radius.circular(7)
                              : Radius.zero,
                        ),
                        highlightColor: Colors.white10,
                        splashColor:    Colors.white10,
                        child: SizedBox(
                          height: itemH,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                entries[i].$2,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: fg,
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w400,
                                  letterSpacing: 0.1,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );

  if (result == null) return;

  switch (result) {
    case 'select_all':
      bloc.add(UpdateSelection(
        selection: TextSelection(baseOffset: 0, extentOffset: text.length),
        pageIndex: pageIndex,
      ));

    case 'copy':
      if (hasSelection) {
        await Clipboard.setData(
          ClipboardData(text: text.substring(selection!.start, selection.end)),
        );
      }

    case 'cut':
      if (hasSelection) {
        await Clipboard.setData(
          ClipboardData(text: text.substring(selection!.start, selection.end)),
        );
        final newText = text.substring(0, selection.start) +
            text.substring(selection.end);
        bloc.add(UpdateNoteText(
          text: newText,
          pageIndex: pageIndex,
          blockId: textBlock.id,
          selection: TextSelection.collapsed(offset: selection.start),
        ));
      }

    case 'paste':
      final data = await Clipboard.getData(Clipboard.kTextPlain);
      if (data?.text == null) return;
      final pasteText = data!.text!;
      final insertAt  = hasSelection ? selection!.start : (selection?.extentOffset ?? text.length);
      final deleteEnd = hasSelection ? selection!.end   : insertAt;
      final newText   = text.substring(0, insertAt) + pasteText + text.substring(deleteEnd);
      bloc.add(UpdateNoteText(
        text: newText,
        pageIndex: pageIndex,
        blockId: textBlock.id,
        selection: TextSelection.collapsed(offset: insertAt + pasteText.length),
      ));
  }
}
