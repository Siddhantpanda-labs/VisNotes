import 'package:flutter/material.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import '../../domain/entities/stroke.dart';
import '../../domain/entities/text_content.dart';
import '../models/isar_note_model.dart';

class NoteMapper {
  static IsarNoteDocument toIsar(NoteDocument domain) {
    return IsarNoteDocument()
      ..id = domain.id
      ..title = domain.title
      ..createdAt = domain.createdAt
      ..updatedAt = domain.updatedAt
      ..parentFolderId = domain.parentFolderId
      ..pages = domain.pages.map((p) => _toIsarPage(p)).toList();
  }

  static NoteDocument toDomain(IsarNoteDocument isar) {
    return NoteDocument(
      id: isar.id ?? '',
      title: isar.title ?? '',
      createdAt: isar.createdAt ?? DateTime.now(),
      updatedAt: isar.updatedAt ?? DateTime.now(),
      parentFolderId: isar.parentFolderId,
      pages: isar.pages.map((p) => _toDomainPage(p)).toList(),
    );
  }

  static IsarNotePage _toIsarPage(NotePage domain) {
    return IsarNotePage()
      ..id = domain.id
      ..width = domain.width
      ..height = domain.height
      ..blocks = domain.blocks.map((b) => _toIsarBlock(b)).toList();
  }

  static NotePage _toDomainPage(IsarNotePage isar) {
    return NotePage(
      id: isar.id ?? '',
      width: isar.width,
      height: isar.height,
      blocks: isar.blocks.map((b) => _toDomainBlock(b)).toList(),
    );
  }

  static IsarNoteBlock _toIsarBlock(NoteBlock domain) {
    final isar = IsarNoteBlock()
      ..id = domain.id
      ..x = domain.position.dx
      ..y = domain.position.dy
      ..width = domain.size.width
      ..height = domain.size.height;

    if (domain is TextBlock) {
      isar.type = 'text';
      isar.textContent = IsarRichTextContent()
        ..segments = domain.content.segments.map((s) => IsarTextSegment()
          ..text = s.text
          ..isBold = s.isBold
          ..isItalic = s.isItalic
          ..isHeading = s.isHeading
          ..fontSize = s.fontSize ?? 16.0
          ..colorValue = s.color?.value ?? 0xFF000000
        ).toList();
    } else if (domain is CanvasBlock) {
      isar.type = 'canvas';
      isar.strokes = domain.strokes.map((s) => IsarStroke()
        ..points = s.points.map((p) => IsarPoint()..x = p.dx..y = p.dy).toList()
        ..pressures = s.pressures
        ..colorValue = s.color.value
        ..width = s.width
      ).toList();
    }
    return isar;
  }

  static NoteBlock _toDomainBlock(IsarNoteBlock isar) {
    final position = Offset(isar.x, isar.y);
    final size = Size(isar.width, isar.height);

    if (isar.type == 'text' && isar.textContent != null) {
      return TextBlock(
        id: isar.id ?? '',
        position: position,
        size: size,
        content: RichTextContent(
          segments: isar.textContent!.segments.map((s) => TextSegment(
            text: s.text ?? '',
            isBold: s.isBold,
            isItalic: s.isItalic,
            isHeading: s.isHeading,
            fontSize: s.fontSize,
            color: Color(s.colorValue),
          )).toList(),
        ),
      );
    } else {
      return CanvasBlock(
        id: isar.id ?? '',
        position: position,
        size: size,
        strokes: isar.strokes.map((s) => Stroke(
          points: s.points.map((p) => Offset(p.x, p.y)).toList(),
          pressures: s.pressures,
          color: Color(s.colorValue),
          width: s.width,
        )).toList(),
      );
    }
  }
}
