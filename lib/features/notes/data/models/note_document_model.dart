import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/note_block.dart';
import '../../domain/entities/note_document.dart';
import 'note_block_model.dart';

part 'note_document_model.g.dart';

@JsonSerializable()
class NoteDocumentModel extends NoteDocument {
  @override
  @JsonKey(
    fromJson: _pagesFromJson,
    toJson: _pagesToJson,
  )
  final List<NotePageModel> pages;

  const NoteDocumentModel({
    required super.id,
    required super.title,
    required this.pages,
    required super.createdAt,
    required super.updatedAt,
  }) : super(pages: pages);

  factory NoteDocumentModel.fromEntity(NoteDocument document) {
    return NoteDocumentModel(
      id: document.id,
      title: document.title,
      pages: document.pages.map((p) => NotePageModel.fromEntity(p)).toList(),
      createdAt: document.createdAt,
      updatedAt: document.updatedAt,
    );
  }

  factory NoteDocumentModel.fromJson(Map<String, dynamic> json) => _$NoteDocumentModelFromJson(json);

  Map<String, dynamic> toJson() => _$NoteDocumentModelToJson(this);

  static List<NotePageModel> _pagesFromJson(List<dynamic> json) =>
      json.map((p) => NotePageModel.fromJson(p as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _pagesToJson(List<NotePage> pages) =>
      pages.map((p) => NotePageModel.fromEntity(p).toJson()).toList();
}

@JsonSerializable()
class NotePageModel extends NotePage {
  @override
  @JsonKey(
    fromJson: _blocksFromJson,
    toJson: _blocksToJson,
  )
  final List<NoteBlock> blocks;

  const NotePageModel({
    required super.id,
    required this.blocks,
    super.width,
    super.height,
  }) : super(blocks: blocks);

  factory NotePageModel.fromEntity(NotePage page) {
    return NotePageModel(
      id: page.id,
      blocks: page.blocks,
      width: page.width,
      height: page.height,
    );
  }

  factory NotePageModel.fromJson(Map<String, dynamic> json) => _$NotePageModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotePageModelToJson(this);

  static List<NoteBlock> _blocksFromJson(List<dynamic> json) =>
      json.map((b) => NoteBlockMapper.fromJson(b as Map<String, dynamic>)).toList();

  static List<Map<String, dynamic>> _blocksToJson(List<NoteBlock> blocks) =>
      blocks.map((b) => NoteBlockMapper.toJson(b)).toList();
}
