import 'package:equatable/equatable.dart';
import 'note_block.dart';

class NoteDocument extends Equatable {
  final String id;
  final String title;
  final List<NotePage> pages;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? parentFolderId;
  final String noteType;

  const NoteDocument({
    required this.id,
    required this.title,
    required this.pages,
    required this.createdAt,
    required this.updatedAt,
    this.parentFolderId,
    this.noteType = 'text',
  });

  NoteDocument copyWith({
    String? id,
    String? title,
    List<NotePage>? pages,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? parentFolderId,
    String? noteType,
  }) {
    return NoteDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      pages: pages ?? this.pages,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      parentFolderId: parentFolderId ?? this.parentFolderId,
      noteType: noteType ?? this.noteType,
    );
  }

  @override
  List<Object?> get props => [id, title, pages, createdAt, updatedAt, parentFolderId, noteType];
}

class NotePage extends Equatable {
  final String id;
  final List<NoteBlock> blocks;
  final double width;
  final double height;

  const NotePage({
    required this.id,
    required this.blocks,
    this.width = 792.0, // 3:4 aspect ratio (width)
    this.height = 1056.0, // 3:4 aspect ratio (height)
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
