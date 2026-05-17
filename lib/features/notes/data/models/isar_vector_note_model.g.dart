// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_vector_note_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarVectorNoteDocumentCollection on Isar {
  IsarCollection<IsarVectorNoteDocument> get isarVectorNoteDocuments =>
      this.collection();
}

const IsarVectorNoteDocumentSchema = CollectionSchema(
  name: r'IsarVectorNoteDocument',
  id: -6406502337659923789,
  properties: {
    r'adminEmails': PropertySchema(
      id: 0,
      name: r'adminEmails',
      type: IsarType.stringList,
    ),
    r'collaborators': PropertySchema(
      id: 1,
      name: r'collaborators',
      type: IsarType.stringList,
    ),
    r'createdAt': PropertySchema(
      id: 2,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dashboardX': PropertySchema(
      id: 3,
      name: r'dashboardX',
      type: IsarType.double,
    ),
    r'dashboardY': PropertySchema(
      id: 4,
      name: r'dashboardY',
      type: IsarType.double,
    ),
    r'deletedAt': PropertySchema(
      id: 5,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'driveFileId': PropertySchema(
      id: 6,
      name: r'driveFileId',
      type: IsarType.string,
    ),
    r'elements': PropertySchema(
      id: 7,
      name: r'elements',
      type: IsarType.objectList,
      target: r'IsarVectorElement',
    ),
    r'id': PropertySchema(
      id: 8,
      name: r'id',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 9,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isPinned': PropertySchema(
      id: 10,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'isShared': PropertySchema(
      id: 11,
      name: r'isShared',
      type: IsarType.bool,
    ),
    r'lastEditedBy': PropertySchema(
      id: 12,
      name: r'lastEditedBy',
      type: IsarType.string,
    ),
    r'ownerEmail': PropertySchema(
      id: 13,
      name: r'ownerEmail',
      type: IsarType.string,
    ),
    r'parentFolderId': PropertySchema(
      id: 14,
      name: r'parentFolderId',
      type: IsarType.string,
    ),
    r'title': PropertySchema(
      id: 15,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 16,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarVectorNoteDocumentEstimateSize,
  serialize: _isarVectorNoteDocumentSerialize,
  deserialize: _isarVectorNoteDocumentDeserialize,
  deserializeProp: _isarVectorNoteDocumentDeserializeProp,
  idName: r'isarId',
  indexes: {
    r'id': IndexSchema(
      id: -3268401673993471357,
      name: r'id',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'id',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {
    r'IsarVectorElement': IsarVectorElementSchema,
    r'IsarVectorPoint': IsarVectorPointSchema
  },
  getId: _isarVectorNoteDocumentGetId,
  getLinks: _isarVectorNoteDocumentGetLinks,
  attach: _isarVectorNoteDocumentAttach,
  version: '3.1.0+1',
);

int _isarVectorNoteDocumentEstimateSize(
  IsarVectorNoteDocument object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.adminEmails.length * 3;
  {
    for (var i = 0; i < object.adminEmails.length; i++) {
      final value = object.adminEmails[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.collaborators.length * 3;
  {
    for (var i = 0; i < object.collaborators.length; i++) {
      final value = object.collaborators[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.driveFileId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.elements.length * 3;
  {
    final offsets = allOffsets[IsarVectorElement]!;
    for (var i = 0; i < object.elements.length; i++) {
      final value = object.elements[i];
      bytesCount +=
          IsarVectorElementSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.lastEditedBy;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.ownerEmail;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.parentFolderId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.title;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarVectorNoteDocumentSerialize(
  IsarVectorNoteDocument object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.adminEmails);
  writer.writeStringList(offsets[1], object.collaborators);
  writer.writeDateTime(offsets[2], object.createdAt);
  writer.writeDouble(offsets[3], object.dashboardX);
  writer.writeDouble(offsets[4], object.dashboardY);
  writer.writeDateTime(offsets[5], object.deletedAt);
  writer.writeString(offsets[6], object.driveFileId);
  writer.writeObjectList<IsarVectorElement>(
    offsets[7],
    allOffsets,
    IsarVectorElementSchema.serialize,
    object.elements,
  );
  writer.writeString(offsets[8], object.id);
  writer.writeBool(offsets[9], object.isDeleted);
  writer.writeBool(offsets[10], object.isPinned);
  writer.writeBool(offsets[11], object.isShared);
  writer.writeString(offsets[12], object.lastEditedBy);
  writer.writeString(offsets[13], object.ownerEmail);
  writer.writeString(offsets[14], object.parentFolderId);
  writer.writeString(offsets[15], object.title);
  writer.writeDateTime(offsets[16], object.updatedAt);
}

IsarVectorNoteDocument _isarVectorNoteDocumentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarVectorNoteDocument();
  object.adminEmails = reader.readStringList(offsets[0]) ?? [];
  object.collaborators = reader.readStringList(offsets[1]) ?? [];
  object.createdAt = reader.readDateTimeOrNull(offsets[2]);
  object.dashboardX = reader.readDouble(offsets[3]);
  object.dashboardY = reader.readDouble(offsets[4]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[5]);
  object.driveFileId = reader.readStringOrNull(offsets[6]);
  object.elements = reader.readObjectList<IsarVectorElement>(
        offsets[7],
        IsarVectorElementSchema.deserialize,
        allOffsets,
        IsarVectorElement(),
      ) ??
      [];
  object.id = reader.readStringOrNull(offsets[8]);
  object.isDeleted = reader.readBool(offsets[9]);
  object.isPinned = reader.readBool(offsets[10]);
  object.isShared = reader.readBool(offsets[11]);
  object.isarId = id;
  object.lastEditedBy = reader.readStringOrNull(offsets[12]);
  object.ownerEmail = reader.readStringOrNull(offsets[13]);
  object.parentFolderId = reader.readStringOrNull(offsets[14]);
  object.title = reader.readStringOrNull(offsets[15]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[16]);
  return object;
}

P _isarVectorNoteDocumentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readObjectList<IsarVectorElement>(
            offset,
            IsarVectorElementSchema.deserialize,
            allOffsets,
            IsarVectorElement(),
          ) ??
          []) as P;
    case 8:
      return (reader.readStringOrNull(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readBool(offset)) as P;
    case 12:
      return (reader.readStringOrNull(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readStringOrNull(offset)) as P;
    case 16:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarVectorNoteDocumentGetId(IsarVectorNoteDocument object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarVectorNoteDocumentGetLinks(
    IsarVectorNoteDocument object) {
  return [];
}

void _isarVectorNoteDocumentAttach(
    IsarCollection<dynamic> col, Id id, IsarVectorNoteDocument object) {
  object.isarId = id;
}

extension IsarVectorNoteDocumentByIndex
    on IsarCollection<IsarVectorNoteDocument> {
  Future<IsarVectorNoteDocument?> getById(String? id) {
    return getByIndex(r'id', [id]);
  }

  IsarVectorNoteDocument? getByIdSync(String? id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String? id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String? id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarVectorNoteDocument?>> getAllById(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarVectorNoteDocument?> getAllByIdSync(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'id', values);
  }

  Future<int> deleteAllById(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'id', values);
  }

  int deleteAllByIdSync(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'id', values);
  }

  Future<Id> putById(IsarVectorNoteDocument object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarVectorNoteDocument object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarVectorNoteDocument> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<IsarVectorNoteDocument> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarVectorNoteDocumentQueryWhereSort
    on QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QWhere> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterWhere>
      anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarVectorNoteDocumentQueryWhere on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QWhereClause> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> isarIdNotEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: isarId, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: isarId, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> isarIdBetween(
    Id lowerIsarId,
    Id upperIsarId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerIsarId,
        includeLower: includeLower,
        upper: upperIsarId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> idEqualTo(String? id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterWhereClause> idNotEqualTo(String? id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [id],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'id',
              lower: [],
              upper: [id],
              includeUpper: false,
            ));
      }
    });
  }
}

extension IsarVectorNoteDocumentQueryFilter on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QFilterCondition> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'adminEmails',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      adminEmailsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'adminEmails',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      adminEmailsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'adminEmails',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'adminEmails',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'adminEmails',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> adminEmailsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'adminEmails',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'collaborators',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      collaboratorsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'collaborators',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      collaboratorsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'collaborators',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'collaborators',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'collaborators',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> collaboratorsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'collaborators',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dashboardX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dashboardX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dashboardX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dashboardX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'dashboardY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'dashboardY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'dashboardY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> dashboardYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'dashboardY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'driveFileId',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'driveFileId',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'driveFileId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      driveFileIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'driveFileId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      driveFileIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'driveFileId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'driveFileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> driveFileIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'driveFileId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'elements',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isPinnedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isSharedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isShared',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isarIdGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isarIdLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> isarIdBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'isarId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastEditedBy',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastEditedBy',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastEditedBy',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      lastEditedByContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lastEditedBy',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      lastEditedByMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lastEditedBy',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastEditedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> lastEditedByIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lastEditedBy',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'ownerEmail',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'ownerEmail',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ownerEmail',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      ownerEmailContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'ownerEmail',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      ownerEmailMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'ownerEmail',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ownerEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> ownerEmailIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'ownerEmail',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'parentFolderId',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'parentFolderId',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'parentFolderId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      parentFolderIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'parentFolderId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      parentFolderIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'parentFolderId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'parentFolderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> parentFolderIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'parentFolderId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
          QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> updatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'updatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarVectorNoteDocumentQueryObject on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QFilterCondition> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument,
      QAfterFilterCondition> elementsElement(FilterQuery<IsarVectorElement> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'elements');
    });
  }
}

extension IsarVectorNoteDocumentQueryLinks on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QFilterCondition> {}

extension IsarVectorNoteDocumentQuerySortBy
    on QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QSortBy> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDriveFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driveFileId', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByDriveFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driveFileId', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShared', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByIsSharedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShared', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByLastEditedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedBy', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByLastEditedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedBy', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByOwnerEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByOwnerEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByParentFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentFolderId', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByParentFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentFolderId', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarVectorNoteDocumentQuerySortThenBy on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QSortThenBy> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDriveFileId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driveFileId', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByDriveFileIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'driveFileId', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShared', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsSharedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isShared', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByLastEditedBy() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedBy', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByLastEditedByDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastEditedBy', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByOwnerEmail() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByOwnerEmailDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ownerEmail', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByParentFolderId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentFolderId', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByParentFolderIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'parentFolderId', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarVectorNoteDocumentQueryWhereDistinct
    on QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct> {
  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByAdminEmails() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'adminEmails');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByCollaborators() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'collaborators');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardX');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardY');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByDriveFileId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'driveFileId', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctById({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByIsShared() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isShared');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByLastEditedBy({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastEditedBy', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByOwnerEmail({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ownerEmail', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByParentFolderId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'parentFolderId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarVectorNoteDocument, IsarVectorNoteDocument, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarVectorNoteDocumentQueryProperty on QueryBuilder<
    IsarVectorNoteDocument, IsarVectorNoteDocument, QQueryProperty> {
  QueryBuilder<IsarVectorNoteDocument, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, List<String>, QQueryOperations>
      adminEmailsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'adminEmails');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, List<String>, QQueryOperations>
      collaboratorsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'collaborators');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, double, QQueryOperations>
      dashboardXProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardX');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, double, QQueryOperations>
      dashboardYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardY');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations>
      driveFileIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'driveFileId');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, List<IsarVectorElement>,
      QQueryOperations> elementsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'elements');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, bool, QQueryOperations>
      isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, bool, QQueryOperations>
      isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, bool, QQueryOperations>
      isSharedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isShared');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations>
      lastEditedByProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastEditedBy');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations>
      ownerEmailProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ownerEmail');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations>
      parentFolderIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'parentFolderId');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, String?, QQueryOperations>
      titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarVectorNoteDocument, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarVectorElementSchema = Schema(
  name: r'IsarVectorElement',
  id: -708431488499603787,
  properties: {
    r'connectorColorValue': PropertySchema(
      id: 0,
      name: r'connectorColorValue',
      type: IsarType.long,
    ),
    r'connectorStrokeWidth': PropertySchema(
      id: 1,
      name: r'connectorStrokeWidth',
      type: IsarType.double,
    ),
    r'filePath': PropertySchema(
      id: 2,
      name: r'filePath',
      type: IsarType.string,
    ),
    r'fontSize': PropertySchema(
      id: 3,
      name: r'fontSize',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 4,
      name: r'id',
      type: IsarType.string,
    ),
    r'isBold': PropertySchema(
      id: 5,
      name: r'isBold',
      type: IsarType.bool,
    ),
    r'isDashed': PropertySchema(
      id: 6,
      name: r'isDashed',
      type: IsarType.bool,
    ),
    r'isItalic': PropertySchema(
      id: 7,
      name: r'isItalic',
      type: IsarType.bool,
    ),
    r'isLocked': PropertySchema(
      id: 8,
      name: r'isLocked',
      type: IsarType.bool,
    ),
    r'photoHeight': PropertySchema(
      id: 9,
      name: r'photoHeight',
      type: IsarType.double,
    ),
    r'photoWidth': PropertySchema(
      id: 10,
      name: r'photoWidth',
      type: IsarType.double,
    ),
    r'positionX': PropertySchema(
      id: 11,
      name: r'positionX',
      type: IsarType.double,
    ),
    r'positionY': PropertySchema(
      id: 12,
      name: r'positionY',
      type: IsarType.double,
    ),
    r'pressures': PropertySchema(
      id: 13,
      name: r'pressures',
      type: IsarType.doubleList,
    ),
    r'rotation': PropertySchema(
      id: 14,
      name: r'rotation',
      type: IsarType.double,
    ),
    r'scale': PropertySchema(
      id: 15,
      name: r'scale',
      type: IsarType.double,
    ),
    r'sourceAnchorX': PropertySchema(
      id: 16,
      name: r'sourceAnchorX',
      type: IsarType.double,
    ),
    r'sourceAnchorY': PropertySchema(
      id: 17,
      name: r'sourceAnchorY',
      type: IsarType.double,
    ),
    r'sourceId': PropertySchema(
      id: 18,
      name: r'sourceId',
      type: IsarType.string,
    ),
    r'strokeColorValue': PropertySchema(
      id: 19,
      name: r'strokeColorValue',
      type: IsarType.long,
    ),
    r'strokePoints': PropertySchema(
      id: 20,
      name: r'strokePoints',
      type: IsarType.objectList,
      target: r'IsarVectorPoint',
    ),
    r'strokeWidth': PropertySchema(
      id: 21,
      name: r'strokeWidth',
      type: IsarType.double,
    ),
    r'targetAnchorX': PropertySchema(
      id: 22,
      name: r'targetAnchorX',
      type: IsarType.double,
    ),
    r'targetAnchorY': PropertySchema(
      id: 23,
      name: r'targetAnchorY',
      type: IsarType.double,
    ),
    r'targetId': PropertySchema(
      id: 24,
      name: r'targetId',
      type: IsarType.string,
    ),
    r'text': PropertySchema(
      id: 25,
      name: r'text',
      type: IsarType.string,
    ),
    r'textBgColorValue': PropertySchema(
      id: 26,
      name: r'textBgColorValue',
      type: IsarType.long,
    ),
    r'textColorValue': PropertySchema(
      id: 27,
      name: r'textColorValue',
      type: IsarType.long,
    ),
    r'textSizeHeight': PropertySchema(
      id: 28,
      name: r'textSizeHeight',
      type: IsarType.double,
    ),
    r'textSizeWidth': PropertySchema(
      id: 29,
      name: r'textSizeWidth',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 30,
      name: r'type',
      type: IsarType.string,
    )
  },
  estimateSize: _isarVectorElementEstimateSize,
  serialize: _isarVectorElementSerialize,
  deserialize: _isarVectorElementDeserialize,
  deserializeProp: _isarVectorElementDeserializeProp,
);

int _isarVectorElementEstimateSize(
  IsarVectorElement object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.filePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pressures.length * 8;
  {
    final value = object.sourceId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.strokePoints.length * 3;
  {
    final offsets = allOffsets[IsarVectorPoint]!;
    for (var i = 0; i < object.strokePoints.length; i++) {
      final value = object.strokePoints[i];
      bytesCount +=
          IsarVectorPointSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.targetId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.type;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarVectorElementSerialize(
  IsarVectorElement object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.connectorColorValue);
  writer.writeDouble(offsets[1], object.connectorStrokeWidth);
  writer.writeString(offsets[2], object.filePath);
  writer.writeDouble(offsets[3], object.fontSize);
  writer.writeString(offsets[4], object.id);
  writer.writeBool(offsets[5], object.isBold);
  writer.writeBool(offsets[6], object.isDashed);
  writer.writeBool(offsets[7], object.isItalic);
  writer.writeBool(offsets[8], object.isLocked);
  writer.writeDouble(offsets[9], object.photoHeight);
  writer.writeDouble(offsets[10], object.photoWidth);
  writer.writeDouble(offsets[11], object.positionX);
  writer.writeDouble(offsets[12], object.positionY);
  writer.writeDoubleList(offsets[13], object.pressures);
  writer.writeDouble(offsets[14], object.rotation);
  writer.writeDouble(offsets[15], object.scale);
  writer.writeDouble(offsets[16], object.sourceAnchorX);
  writer.writeDouble(offsets[17], object.sourceAnchorY);
  writer.writeString(offsets[18], object.sourceId);
  writer.writeLong(offsets[19], object.strokeColorValue);
  writer.writeObjectList<IsarVectorPoint>(
    offsets[20],
    allOffsets,
    IsarVectorPointSchema.serialize,
    object.strokePoints,
  );
  writer.writeDouble(offsets[21], object.strokeWidth);
  writer.writeDouble(offsets[22], object.targetAnchorX);
  writer.writeDouble(offsets[23], object.targetAnchorY);
  writer.writeString(offsets[24], object.targetId);
  writer.writeString(offsets[25], object.text);
  writer.writeLong(offsets[26], object.textBgColorValue);
  writer.writeLong(offsets[27], object.textColorValue);
  writer.writeDouble(offsets[28], object.textSizeHeight);
  writer.writeDouble(offsets[29], object.textSizeWidth);
  writer.writeString(offsets[30], object.type);
}

IsarVectorElement _isarVectorElementDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarVectorElement();
  object.connectorColorValue = reader.readLong(offsets[0]);
  object.connectorStrokeWidth = reader.readDouble(offsets[1]);
  object.filePath = reader.readStringOrNull(offsets[2]);
  object.fontSize = reader.readDouble(offsets[3]);
  object.id = reader.readStringOrNull(offsets[4]);
  object.isBold = reader.readBool(offsets[5]);
  object.isDashed = reader.readBool(offsets[6]);
  object.isItalic = reader.readBool(offsets[7]);
  object.isLocked = reader.readBool(offsets[8]);
  object.photoHeight = reader.readDouble(offsets[9]);
  object.photoWidth = reader.readDouble(offsets[10]);
  object.positionX = reader.readDouble(offsets[11]);
  object.positionY = reader.readDouble(offsets[12]);
  object.pressures = reader.readDoubleList(offsets[13]) ?? [];
  object.rotation = reader.readDouble(offsets[14]);
  object.scale = reader.readDouble(offsets[15]);
  object.sourceAnchorX = reader.readDouble(offsets[16]);
  object.sourceAnchorY = reader.readDouble(offsets[17]);
  object.sourceId = reader.readStringOrNull(offsets[18]);
  object.strokeColorValue = reader.readLong(offsets[19]);
  object.strokePoints = reader.readObjectList<IsarVectorPoint>(
        offsets[20],
        IsarVectorPointSchema.deserialize,
        allOffsets,
        IsarVectorPoint(),
      ) ??
      [];
  object.strokeWidth = reader.readDouble(offsets[21]);
  object.targetAnchorX = reader.readDouble(offsets[22]);
  object.targetAnchorY = reader.readDouble(offsets[23]);
  object.targetId = reader.readStringOrNull(offsets[24]);
  object.text = reader.readStringOrNull(offsets[25]);
  object.textBgColorValue = reader.readLong(offsets[26]);
  object.textColorValue = reader.readLong(offsets[27]);
  object.textSizeHeight = reader.readDouble(offsets[28]);
  object.textSizeWidth = reader.readDouble(offsets[29]);
  object.type = reader.readStringOrNull(offsets[30]);
  return object;
}

P _isarVectorElementDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readBool(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDouble(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 14:
      return (reader.readDouble(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    case 16:
      return (reader.readDouble(offset)) as P;
    case 17:
      return (reader.readDouble(offset)) as P;
    case 18:
      return (reader.readStringOrNull(offset)) as P;
    case 19:
      return (reader.readLong(offset)) as P;
    case 20:
      return (reader.readObjectList<IsarVectorPoint>(
            offset,
            IsarVectorPointSchema.deserialize,
            allOffsets,
            IsarVectorPoint(),
          ) ??
          []) as P;
    case 21:
      return (reader.readDouble(offset)) as P;
    case 22:
      return (reader.readDouble(offset)) as P;
    case 23:
      return (reader.readDouble(offset)) as P;
    case 24:
      return (reader.readStringOrNull(offset)) as P;
    case 25:
      return (reader.readStringOrNull(offset)) as P;
    case 26:
      return (reader.readLong(offset)) as P;
    case 27:
      return (reader.readLong(offset)) as P;
    case 28:
      return (reader.readDouble(offset)) as P;
    case 29:
      return (reader.readDouble(offset)) as P;
    case 30:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarVectorElementQueryFilter
    on QueryBuilder<IsarVectorElement, IsarVectorElement, QFilterCondition> {
  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectorColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectorColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectorColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectorColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorStrokeWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'connectorStrokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorStrokeWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'connectorStrokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorStrokeWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'connectorStrokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      connectorStrokeWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'connectorStrokeWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'filePath',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'filePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'filePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'filePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      filePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'filePath',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      fontSizeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      fontSizeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      fontSizeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fontSize',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      fontSizeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fontSize',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      isBoldEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBold',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      isDashedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDashed',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      isItalicEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isItalic',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      isLockedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isLocked',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'photoWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'photoWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'photoWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      photoWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'photoWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'positionY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'positionY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'positionY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      positionYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'positionY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'pressures',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'pressures',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'pressures',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'pressures',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      pressuresLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pressures',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      rotationEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rotation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      rotationGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rotation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      rotationLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rotation',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      rotationBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rotation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      scaleEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'scale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      scaleGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'scale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      scaleLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'scale',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      scaleBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'scale',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceAnchorX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceAnchorYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceAnchorY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceId',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      sourceIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strokeColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strokeColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strokeColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strokeColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokePoints',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'strokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'strokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'strokeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokeWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'strokeWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorXEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorXGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorXLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetAnchorX',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorXBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetAnchorX',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorYEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorYGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorYLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetAnchorY',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetAnchorYBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetAnchorY',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'targetId',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'targetId',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      targetIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetId',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'text',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textBgColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textBgColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textBgColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textBgColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textBgColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textBgColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textBgColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textBgColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textColorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textColorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textColorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textColorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textColorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textColorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeHeightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textSizeHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeHeightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textSizeHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeHeightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textSizeHeight',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeHeightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textSizeHeight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeWidthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'textSizeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeWidthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'textSizeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeWidthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'textSizeWidth',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      textSizeWidthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'textSizeWidth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }
}

extension IsarVectorElementQueryObject
    on QueryBuilder<IsarVectorElement, IsarVectorElement, QFilterCondition> {
  QueryBuilder<IsarVectorElement, IsarVectorElement, QAfterFilterCondition>
      strokePointsElement(FilterQuery<IsarVectorPoint> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'strokePoints');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarVectorPointSchema = Schema(
  name: r'IsarVectorPoint',
  id: -7414224945478935902,
  properties: {
    r'x': PropertySchema(
      id: 0,
      name: r'x',
      type: IsarType.double,
    ),
    r'y': PropertySchema(
      id: 1,
      name: r'y',
      type: IsarType.double,
    )
  },
  estimateSize: _isarVectorPointEstimateSize,
  serialize: _isarVectorPointSerialize,
  deserialize: _isarVectorPointDeserialize,
  deserializeProp: _isarVectorPointDeserializeProp,
);

int _isarVectorPointEstimateSize(
  IsarVectorPoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _isarVectorPointSerialize(
  IsarVectorPoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.x);
  writer.writeDouble(offsets[1], object.y);
}

IsarVectorPoint _isarVectorPointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarVectorPoint();
  object.x = reader.readDouble(offsets[0]);
  object.y = reader.readDouble(offsets[1]);
  return object;
}

P _isarVectorPointDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarVectorPointQueryFilter
    on QueryBuilder<IsarVectorPoint, IsarVectorPoint, QFilterCondition> {
  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      xEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      xGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      xLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'x',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      xBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'x',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      yEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      yGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      yLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'y',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarVectorPoint, IsarVectorPoint, QAfterFilterCondition>
      yBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'y',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IsarVectorPointQueryObject
    on QueryBuilder<IsarVectorPoint, IsarVectorPoint, QFilterCondition> {}
