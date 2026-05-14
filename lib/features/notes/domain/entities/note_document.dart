import 'package:equatable/equatable.dart';
import 'note_block.dart';

class NoteDocument extends Equatable {
  final String id;
  final String title;
  final List<NotePage> pages;
  final DateTime createdAt;
  final DateTime updatedAt;

  const NoteDocument({
    required this.id,
    required this.title,
    required this.pages,
    required this.createdAt,
    required this.updatedAt,
  });

  NoteDocument copyWith({
    String? id,
    String? title,
    List<NotePage>? pages,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return NoteDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, title, pages, createdAt, updatedAt];
}

class NotePage extends Equatable {
  final String id;
  final List<NoteBlock> blocks;
  final double width;
  final double height;

  const NotePage({
    required this.id,
    required this.blocks,
    this.width = 595.0, // A4 width in points at 72 DPI
    this.height = 842.0, // A4 height in points at 72 DPI
  });

  NotePage copyWith({
    String? id,
    List<NoteBlock>? blocks,
    double? width,
    double? height,
  }) {
    return NotePage(
      id: id ?? this.id,
      blocks: blocks ?? this.blocks,
      width: width ?? this.width,
      height: height ?? this.height,
    );
  }

  @override
  List<Object?> get props => [id, blocks, width, height];
}
