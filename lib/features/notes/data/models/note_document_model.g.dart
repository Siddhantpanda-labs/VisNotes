// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_document_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NoteDocumentModel _$NoteDocumentModelFromJson(Map<String, dynamic> json) =>
    NoteDocumentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      pages: NoteDocumentModel._pagesFromJson(json['pages'] as List),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$NoteDocumentModelToJson(NoteDocumentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'pages': NoteDocumentModel._pagesToJson(instance.pages),
    };

NotePageModel _$NotePageModelFromJson(Map<String, dynamic> json) =>
    NotePageModel(
      id: json['id'] as String,
      blocks: NotePageModel._blocksFromJson(json['blocks'] as List),
      width: (json['width'] as num?)?.toDouble() ?? 595.0,
      height: (json['height'] as num?)?.toDouble() ?? 842.0,
    );

Map<String, dynamic> _$NotePageModelToJson(NotePageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'width': instance.width,
      'height': instance.height,
      'blocks': NotePageModel._blocksToJson(instance.blocks),
    };
