// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_note_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarNoteDocumentCollection on Isar {
  IsarCollection<IsarNoteDocument> get isarNoteDocuments => this.collection();
}

const IsarNoteDocumentSchema = CollectionSchema(
  name: r'IsarNoteDocument',
  id: -3330625021260316957,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'dashboardX': PropertySchema(
      id: 1,
      name: r'dashboardX',
      type: IsarType.double,
    ),
    r'dashboardY': PropertySchema(
      id: 2,
      name: r'dashboardY',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'isPinned': PropertySchema(
      id: 4,
      name: r'isPinned',
      type: IsarType.bool,
    ),
    r'pages': PropertySchema(
      id: 5,
      name: r'pages',
      type: IsarType.objectList,
      target: r'IsarNotePage',
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'updatedAt': PropertySchema(
      id: 7,
      name: r'updatedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _isarNoteDocumentEstimateSize,
  serialize: _isarNoteDocumentSerialize,
  deserialize: _isarNoteDocumentDeserialize,
  deserializeProp: _isarNoteDocumentDeserializeProp,
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
    r'IsarNotePage': IsarNotePageSchema,
    r'IsarNoteBlock': IsarNoteBlockSchema,
    r'IsarRichTextContent': IsarRichTextContentSchema,
    r'IsarTextSegment': IsarTextSegmentSchema,
    r'IsarStroke': IsarStrokeSchema,
    r'IsarPoint': IsarPointSchema
  },
  getId: _isarNoteDocumentGetId,
  getLinks: _isarNoteDocumentGetLinks,
  attach: _isarNoteDocumentAttach,
  version: '3.1.0+1',
);

int _isarNoteDocumentEstimateSize(
  IsarNoteDocument object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.pages.length * 3;
  {
    final offsets = allOffsets[IsarNotePage]!;
    for (var i = 0; i < object.pages.length; i++) {
      final value = object.pages[i];
      bytesCount += IsarNotePageSchema.estimateSize(value, offsets, allOffsets);
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

void _isarNoteDocumentSerialize(
  IsarNoteDocument object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeDouble(offsets[1], object.dashboardX);
  writer.writeDouble(offsets[2], object.dashboardY);
  writer.writeString(offsets[3], object.id);
  writer.writeBool(offsets[4], object.isPinned);
  writer.writeObjectList<IsarNotePage>(
    offsets[5],
    allOffsets,
    IsarNotePageSchema.serialize,
    object.pages,
  );
  writer.writeString(offsets[6], object.title);
  writer.writeDateTime(offsets[7], object.updatedAt);
}

IsarNoteDocument _isarNoteDocumentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarNoteDocument();
  object.createdAt = reader.readDateTimeOrNull(offsets[0]);
  object.dashboardX = reader.readDouble(offsets[1]);
  object.dashboardY = reader.readDouble(offsets[2]);
  object.id = reader.readStringOrNull(offsets[3]);
  object.isPinned = reader.readBool(offsets[4]);
  object.isarId = id;
  object.pages = reader.readObjectList<IsarNotePage>(
        offsets[5],
        IsarNotePageSchema.deserialize,
        allOffsets,
        IsarNotePage(),
      ) ??
      [];
  object.title = reader.readStringOrNull(offsets[6]);
  object.updatedAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _isarNoteDocumentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readObjectList<IsarNotePage>(
            offset,
            IsarNotePageSchema.deserialize,
            allOffsets,
            IsarNotePage(),
          ) ??
          []) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarNoteDocumentGetId(IsarNoteDocument object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarNoteDocumentGetLinks(IsarNoteDocument object) {
  return [];
}

void _isarNoteDocumentAttach(
    IsarCollection<dynamic> col, Id id, IsarNoteDocument object) {
  object.isarId = id;
}

extension IsarNoteDocumentByIndex on IsarCollection<IsarNoteDocument> {
  Future<IsarNoteDocument?> getById(String? id) {
    return getByIndex(r'id', [id]);
  }

  IsarNoteDocument? getByIdSync(String? id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String? id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String? id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarNoteDocument?>> getAllById(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarNoteDocument?> getAllByIdSync(List<String?> idValues) {
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

  Future<Id> putById(IsarNoteDocument object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarNoteDocument object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarNoteDocument> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<IsarNoteDocument> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarNoteDocumentQueryWhereSort
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QWhere> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarNoteDocumentQueryWhere
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QWhereClause> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      isarIdEqualTo(Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      isarIdNotEqualTo(Id isarId) {
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      isarIdGreaterThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      isarIdLessThan(Id isarId, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      isarIdBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause> idEqualTo(
      String? id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterWhereClause>
      idNotEqualTo(String? id) {
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

extension IsarNoteDocumentQueryFilter
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QFilterCondition> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'createdAt',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardXEqualTo(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardXGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardXLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardXBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardYEqualTo(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardYGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardYLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      dashboardYBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      isPinnedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinned',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      isarIdEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      isarIdGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      isarIdLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      isarIdBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'pages',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'title',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleEqualTo(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleBetween(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleStartsWith(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleEndsWith(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'updatedAt',
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'updatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtGreaterThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtLessThan(
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

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      updatedAtBetween(
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

extension IsarNoteDocumentQueryObject
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QFilterCondition> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterFilterCondition>
      pagesElement(FilterQuery<IsarNotePage> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'pages');
    });
  }
}

extension IsarNoteDocumentQueryLinks
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QFilterCondition> {}

extension IsarNoteDocumentQuerySortBy
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QSortBy> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      sortByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarNoteDocumentQuerySortThenBy
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QSortThenBy> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByIsPinnedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinned', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.asc);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QAfterSortBy>
      thenByUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'updatedAt', Sort.desc);
    });
  }
}

extension IsarNoteDocumentQueryWhereDistinct
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct> {
  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct>
      distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct>
      distinctByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardX');
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct>
      distinctByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardY');
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct>
      distinctByIsPinned() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinned');
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarNoteDocument, IsarNoteDocument, QDistinct>
      distinctByUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'updatedAt');
    });
  }
}

extension IsarNoteDocumentQueryProperty
    on QueryBuilder<IsarNoteDocument, IsarNoteDocument, QQueryProperty> {
  QueryBuilder<IsarNoteDocument, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarNoteDocument, DateTime?, QQueryOperations>
      createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<IsarNoteDocument, double, QQueryOperations>
      dashboardXProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardX');
    });
  }

  QueryBuilder<IsarNoteDocument, double, QQueryOperations>
      dashboardYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardY');
    });
  }

  QueryBuilder<IsarNoteDocument, String?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarNoteDocument, bool, QQueryOperations> isPinnedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinned');
    });
  }

  QueryBuilder<IsarNoteDocument, List<IsarNotePage>, QQueryOperations>
      pagesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'pages');
    });
  }

  QueryBuilder<IsarNoteDocument, String?, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<IsarNoteDocument, DateTime?, QQueryOperations>
      updatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'updatedAt');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarFolderCollection on Isar {
  IsarCollection<IsarFolder> get isarFolders => this.collection();
}

const IsarFolderSchema = CollectionSchema(
  name: r'IsarFolder',
  id: -7805229368695537870,
  properties: {
    r'childFolderIds': PropertySchema(
      id: 0,
      name: r'childFolderIds',
      type: IsarType.stringList,
    ),
    r'dashboardX': PropertySchema(
      id: 1,
      name: r'dashboardX',
      type: IsarType.double,
    ),
    r'dashboardY': PropertySchema(
      id: 2,
      name: r'dashboardY',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 3,
      name: r'id',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 4,
      name: r'name',
      type: IsarType.string,
    ),
    r'noteIds': PropertySchema(
      id: 5,
      name: r'noteIds',
      type: IsarType.stringList,
    )
  },
  estimateSize: _isarFolderEstimateSize,
  serialize: _isarFolderSerialize,
  deserialize: _isarFolderDeserialize,
  deserializeProp: _isarFolderDeserializeProp,
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
  embeddedSchemas: {},
  getId: _isarFolderGetId,
  getLinks: _isarFolderGetLinks,
  attach: _isarFolderAttach,
  version: '3.1.0+1',
);

int _isarFolderEstimateSize(
  IsarFolder object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.childFolderIds.length * 3;
  {
    for (var i = 0; i < object.childFolderIds.length; i++) {
      final value = object.childFolderIds[i];
      bytesCount += value.length * 3;
    }
  }
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.noteIds.length * 3;
  {
    for (var i = 0; i < object.noteIds.length; i++) {
      final value = object.noteIds[i];
      bytesCount += value.length * 3;
    }
  }
  return bytesCount;
}

void _isarFolderSerialize(
  IsarFolder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeStringList(offsets[0], object.childFolderIds);
  writer.writeDouble(offsets[1], object.dashboardX);
  writer.writeDouble(offsets[2], object.dashboardY);
  writer.writeString(offsets[3], object.id);
  writer.writeString(offsets[4], object.name);
  writer.writeStringList(offsets[5], object.noteIds);
}

IsarFolder _isarFolderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarFolder();
  object.childFolderIds = reader.readStringList(offsets[0]) ?? [];
  object.dashboardX = reader.readDouble(offsets[1]);
  object.dashboardY = reader.readDouble(offsets[2]);
  object.id = reader.readStringOrNull(offsets[3]);
  object.isarId = id;
  object.name = reader.readStringOrNull(offsets[4]);
  object.noteIds = reader.readStringList(offsets[5]) ?? [];
  return object;
}

P _isarFolderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringList(offset) ?? []) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readStringOrNull(offset)) as P;
    case 5:
      return (reader.readStringList(offset) ?? []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarFolderGetId(IsarFolder object) {
  return object.isarId;
}

List<IsarLinkBase<dynamic>> _isarFolderGetLinks(IsarFolder object) {
  return [];
}

void _isarFolderAttach(IsarCollection<dynamic> col, Id id, IsarFolder object) {
  object.isarId = id;
}

extension IsarFolderByIndex on IsarCollection<IsarFolder> {
  Future<IsarFolder?> getById(String? id) {
    return getByIndex(r'id', [id]);
  }

  IsarFolder? getByIdSync(String? id) {
    return getByIndexSync(r'id', [id]);
  }

  Future<bool> deleteById(String? id) {
    return deleteByIndex(r'id', [id]);
  }

  bool deleteByIdSync(String? id) {
    return deleteByIndexSync(r'id', [id]);
  }

  Future<List<IsarFolder?>> getAllById(List<String?> idValues) {
    final values = idValues.map((e) => [e]).toList();
    return getAllByIndex(r'id', values);
  }

  List<IsarFolder?> getAllByIdSync(List<String?> idValues) {
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

  Future<Id> putById(IsarFolder object) {
    return putByIndex(r'id', object);
  }

  Id putByIdSync(IsarFolder object, {bool saveLinks = true}) {
    return putByIndexSync(r'id', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllById(List<IsarFolder> objects) {
    return putAllByIndex(r'id', objects);
  }

  List<Id> putAllByIdSync(List<IsarFolder> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'id', objects, saveLinks: saveLinks);
  }
}

extension IsarFolderQueryWhereSort
    on QueryBuilder<IsarFolder, IsarFolder, QWhere> {
  QueryBuilder<IsarFolder, IsarFolder, QAfterWhere> anyIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarFolderQueryWhere
    on QueryBuilder<IsarFolder, IsarFolder, QWhereClause> {
  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> isarIdEqualTo(
      Id isarId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: isarId,
        upper: isarId,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> isarIdNotEqualTo(
      Id isarId) {
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> isarIdGreaterThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: isarId, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> isarIdLessThan(
      Id isarId,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: isarId, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> isarIdBetween(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [null],
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'id',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> idEqualTo(
      String? id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'id',
        value: [id],
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterWhereClause> idNotEqualTo(
      String? id) {
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

extension IsarFolderQueryFilter
    on QueryBuilder<IsarFolder, IsarFolder, QFilterCondition> {
  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'childFolderIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'childFolderIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'childFolderIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'childFolderIds',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'childFolderIds',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      childFolderIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'childFolderIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> dashboardXEqualTo(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      dashboardXGreaterThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      dashboardXLessThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> dashboardXBetween(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> dashboardYEqualTo(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      dashboardYGreaterThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      dashboardYLessThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> dashboardYBetween(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> isarIdEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isarId',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> isarIdGreaterThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> isarIdLessThan(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> isarIdBetween(
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

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'noteIds',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'noteIds',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'noteIds',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'noteIds',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'noteIds',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition> noteIdsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterFilterCondition>
      noteIdsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'noteIds',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarFolderQueryObject
    on QueryBuilder<IsarFolder, IsarFolder, QFilterCondition> {}

extension IsarFolderQueryLinks
    on QueryBuilder<IsarFolder, IsarFolder, QFilterCondition> {}

extension IsarFolderQuerySortBy
    on QueryBuilder<IsarFolder, IsarFolder, QSortBy> {
  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarFolderQuerySortThenBy
    on QueryBuilder<IsarFolder, IsarFolder, QSortThenBy> {
  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByDashboardXDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardX', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByDashboardYDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'dashboardY', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByIsarId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByIsarIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isarId', Sort.desc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }
}

extension IsarFolderQueryWhereDistinct
    on QueryBuilder<IsarFolder, IsarFolder, QDistinct> {
  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctByChildFolderIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'childFolderIds');
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctByDashboardX() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardX');
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctByDashboardY() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'dashboardY');
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctById(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'id', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarFolder, IsarFolder, QDistinct> distinctByNoteIds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'noteIds');
    });
  }
}

extension IsarFolderQueryProperty
    on QueryBuilder<IsarFolder, IsarFolder, QQueryProperty> {
  QueryBuilder<IsarFolder, int, QQueryOperations> isarIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isarId');
    });
  }

  QueryBuilder<IsarFolder, List<String>, QQueryOperations>
      childFolderIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'childFolderIds');
    });
  }

  QueryBuilder<IsarFolder, double, QQueryOperations> dashboardXProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardX');
    });
  }

  QueryBuilder<IsarFolder, double, QQueryOperations> dashboardYProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'dashboardY');
    });
  }

  QueryBuilder<IsarFolder, String?, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarFolder, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<IsarFolder, List<String>, QQueryOperations> noteIdsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'noteIds');
    });
  }
}

// **************************************************************************
// IsarEmbeddedGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarNotePageSchema = Schema(
  name: r'IsarNotePage',
  id: -8718705821563969345,
  properties: {
    r'blocks': PropertySchema(
      id: 0,
      name: r'blocks',
      type: IsarType.objectList,
      target: r'IsarNoteBlock',
    ),
    r'height': PropertySchema(
      id: 1,
      name: r'height',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 2,
      name: r'id',
      type: IsarType.string,
    ),
    r'width': PropertySchema(
      id: 3,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _isarNotePageEstimateSize,
  serialize: _isarNotePageSerialize,
  deserialize: _isarNotePageDeserialize,
  deserializeProp: _isarNotePageDeserializeProp,
);

int _isarNotePageEstimateSize(
  IsarNotePage object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.blocks.length * 3;
  {
    final offsets = allOffsets[IsarNoteBlock]!;
    for (var i = 0; i < object.blocks.length; i++) {
      final value = object.blocks[i];
      bytesCount +=
          IsarNoteBlockSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarNotePageSerialize(
  IsarNotePage object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<IsarNoteBlock>(
    offsets[0],
    allOffsets,
    IsarNoteBlockSchema.serialize,
    object.blocks,
  );
  writer.writeDouble(offsets[1], object.height);
  writer.writeString(offsets[2], object.id);
  writer.writeDouble(offsets[3], object.width);
}

IsarNotePage _isarNotePageDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarNotePage();
  object.blocks = reader.readObjectList<IsarNoteBlock>(
        offsets[0],
        IsarNoteBlockSchema.deserialize,
        allOffsets,
        IsarNoteBlock(),
      ) ??
      [];
  object.height = reader.readDouble(offsets[1]);
  object.id = reader.readStringOrNull(offsets[2]);
  object.width = reader.readDouble(offsets[3]);
  return object;
}

P _isarNotePageDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<IsarNoteBlock>(
            offset,
            IsarNoteBlockSchema.deserialize,
            allOffsets,
            IsarNoteBlock(),
          ) ??
          []) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarNotePageQueryFilter
    on QueryBuilder<IsarNotePage, IsarNotePage, QFilterCondition> {
  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      blocksLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'blocks',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> heightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      heightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      heightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> heightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idStartsWith(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition>
      widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IsarNotePageQueryObject
    on QueryBuilder<IsarNotePage, IsarNotePage, QFilterCondition> {
  QueryBuilder<IsarNotePage, IsarNotePage, QAfterFilterCondition> blocksElement(
      FilterQuery<IsarNoteBlock> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'blocks');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarNoteBlockSchema = Schema(
  name: r'IsarNoteBlock',
  id: -4650197352798817991,
  properties: {
    r'height': PropertySchema(
      id: 0,
      name: r'height',
      type: IsarType.double,
    ),
    r'id': PropertySchema(
      id: 1,
      name: r'id',
      type: IsarType.string,
    ),
    r'opacity': PropertySchema(
      id: 2,
      name: r'opacity',
      type: IsarType.double,
    ),
    r'rotation': PropertySchema(
      id: 3,
      name: r'rotation',
      type: IsarType.double,
    ),
    r'strokes': PropertySchema(
      id: 4,
      name: r'strokes',
      type: IsarType.objectList,
      target: r'IsarStroke',
    ),
    r'textContent': PropertySchema(
      id: 5,
      name: r'textContent',
      type: IsarType.object,
      target: r'IsarRichTextContent',
    ),
    r'type': PropertySchema(
      id: 6,
      name: r'type',
      type: IsarType.string,
    ),
    r'width': PropertySchema(
      id: 7,
      name: r'width',
      type: IsarType.double,
    ),
    r'x': PropertySchema(
      id: 8,
      name: r'x',
      type: IsarType.double,
    ),
    r'y': PropertySchema(
      id: 9,
      name: r'y',
      type: IsarType.double,
    )
  },
  estimateSize: _isarNoteBlockEstimateSize,
  serialize: _isarNoteBlockSerialize,
  deserialize: _isarNoteBlockDeserialize,
  deserializeProp: _isarNoteBlockDeserializeProp,
);

int _isarNoteBlockEstimateSize(
  IsarNoteBlock object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.id;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.strokes.length * 3;
  {
    final offsets = allOffsets[IsarStroke]!;
    for (var i = 0; i < object.strokes.length; i++) {
      final value = object.strokes[i];
      bytesCount += IsarStrokeSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  {
    final value = object.textContent;
    if (value != null) {
      bytesCount += 3 +
          IsarRichTextContentSchema.estimateSize(
              value, allOffsets[IsarRichTextContent]!, allOffsets);
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

void _isarNoteBlockSerialize(
  IsarNoteBlock object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.height);
  writer.writeString(offsets[1], object.id);
  writer.writeDouble(offsets[2], object.opacity);
  writer.writeDouble(offsets[3], object.rotation);
  writer.writeObjectList<IsarStroke>(
    offsets[4],
    allOffsets,
    IsarStrokeSchema.serialize,
    object.strokes,
  );
  writer.writeObject<IsarRichTextContent>(
    offsets[5],
    allOffsets,
    IsarRichTextContentSchema.serialize,
    object.textContent,
  );
  writer.writeString(offsets[6], object.type);
  writer.writeDouble(offsets[7], object.width);
  writer.writeDouble(offsets[8], object.x);
  writer.writeDouble(offsets[9], object.y);
}

IsarNoteBlock _isarNoteBlockDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarNoteBlock();
  object.height = reader.readDouble(offsets[0]);
  object.id = reader.readStringOrNull(offsets[1]);
  object.opacity = reader.readDouble(offsets[2]);
  object.rotation = reader.readDouble(offsets[3]);
  object.strokes = reader.readObjectList<IsarStroke>(
        offsets[4],
        IsarStrokeSchema.deserialize,
        allOffsets,
        IsarStroke(),
      ) ??
      [];
  object.textContent = reader.readObjectOrNull<IsarRichTextContent>(
    offsets[5],
    IsarRichTextContentSchema.deserialize,
    allOffsets,
  );
  object.type = reader.readStringOrNull(offsets[6]);
  object.width = reader.readDouble(offsets[7]);
  object.x = reader.readDouble(offsets[8]);
  object.y = reader.readDouble(offsets[9]);
  return object;
}

P _isarNoteBlockDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDouble(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readObjectList<IsarStroke>(
            offset,
            IsarStrokeSchema.deserialize,
            allOffsets,
            IsarStroke(),
          ) ??
          []) as P;
    case 5:
      return (reader.readObjectOrNull<IsarRichTextContent>(
        offset,
        IsarRichTextContentSchema.deserialize,
        allOffsets,
      )) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarNoteBlockQueryFilter
    on QueryBuilder<IsarNoteBlock, IsarNoteBlock, QFilterCondition> {
  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      heightEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      heightGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      heightLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'height',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      heightBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'height',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idEqualTo(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idBetween(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idEndsWith(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'id',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> idMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'id',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      idIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      idIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'id',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      opacityEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      opacityGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      opacityLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'opacity',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      opacityBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'opacity',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'strokes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      textContentIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'textContent',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      textContentIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'textContent',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      typeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      typeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'type',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> typeEqualTo(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> typeBetween(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      typeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'type',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> typeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'type',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      typeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      typeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'type',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> xEqualTo(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> xLessThan(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> xBetween(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> yEqualTo(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> yLessThan(
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

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> yBetween(
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

extension IsarNoteBlockQueryObject
    on QueryBuilder<IsarNoteBlock, IsarNoteBlock, QFilterCondition> {
  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition>
      strokesElement(FilterQuery<IsarStroke> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'strokes');
    });
  }

  QueryBuilder<IsarNoteBlock, IsarNoteBlock, QAfterFilterCondition> textContent(
      FilterQuery<IsarRichTextContent> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'textContent');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarRichTextContentSchema = Schema(
  name: r'IsarRichTextContent',
  id: -2321256125225349946,
  properties: {
    r'segments': PropertySchema(
      id: 0,
      name: r'segments',
      type: IsarType.objectList,
      target: r'IsarTextSegment',
    )
  },
  estimateSize: _isarRichTextContentEstimateSize,
  serialize: _isarRichTextContentSerialize,
  deserialize: _isarRichTextContentDeserialize,
  deserializeProp: _isarRichTextContentDeserializeProp,
);

int _isarRichTextContentEstimateSize(
  IsarRichTextContent object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.segments.length * 3;
  {
    final offsets = allOffsets[IsarTextSegment]!;
    for (var i = 0; i < object.segments.length; i++) {
      final value = object.segments[i];
      bytesCount +=
          IsarTextSegmentSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  return bytesCount;
}

void _isarRichTextContentSerialize(
  IsarRichTextContent object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeObjectList<IsarTextSegment>(
    offsets[0],
    allOffsets,
    IsarTextSegmentSchema.serialize,
    object.segments,
  );
}

IsarRichTextContent _isarRichTextContentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarRichTextContent();
  object.segments = reader.readObjectList<IsarTextSegment>(
        offsets[0],
        IsarTextSegmentSchema.deserialize,
        allOffsets,
        IsarTextSegment(),
      ) ??
      [];
  return object;
}

P _isarRichTextContentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readObjectList<IsarTextSegment>(
            offset,
            IsarTextSegmentSchema.deserialize,
            allOffsets,
            IsarTextSegment(),
          ) ??
          []) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarRichTextContentQueryFilter on QueryBuilder<IsarRichTextContent,
    IsarRichTextContent, QFilterCondition> {
  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'segments',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }
}

extension IsarRichTextContentQueryObject on QueryBuilder<IsarRichTextContent,
    IsarRichTextContent, QFilterCondition> {
  QueryBuilder<IsarRichTextContent, IsarRichTextContent, QAfterFilterCondition>
      segmentsElement(FilterQuery<IsarTextSegment> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'segments');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarTextSegmentSchema = Schema(
  name: r'IsarTextSegment',
  id: 5261452143247117120,
  properties: {
    r'colorValue': PropertySchema(
      id: 0,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'fontSize': PropertySchema(
      id: 1,
      name: r'fontSize',
      type: IsarType.double,
    ),
    r'isBold': PropertySchema(
      id: 2,
      name: r'isBold',
      type: IsarType.bool,
    ),
    r'isHeading': PropertySchema(
      id: 3,
      name: r'isHeading',
      type: IsarType.bool,
    ),
    r'isItalic': PropertySchema(
      id: 4,
      name: r'isItalic',
      type: IsarType.bool,
    ),
    r'text': PropertySchema(
      id: 5,
      name: r'text',
      type: IsarType.string,
    )
  },
  estimateSize: _isarTextSegmentEstimateSize,
  serialize: _isarTextSegmentSerialize,
  deserialize: _isarTextSegmentDeserialize,
  deserializeProp: _isarTextSegmentDeserializeProp,
);

int _isarTextSegmentEstimateSize(
  IsarTextSegment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.text;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarTextSegmentSerialize(
  IsarTextSegment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorValue);
  writer.writeDouble(offsets[1], object.fontSize);
  writer.writeBool(offsets[2], object.isBold);
  writer.writeBool(offsets[3], object.isHeading);
  writer.writeBool(offsets[4], object.isItalic);
  writer.writeString(offsets[5], object.text);
}

IsarTextSegment _isarTextSegmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarTextSegment();
  object.colorValue = reader.readLong(offsets[0]);
  object.fontSize = reader.readDouble(offsets[1]);
  object.isBold = reader.readBool(offsets[2]);
  object.isHeading = reader.readBool(offsets[3]);
  object.isItalic = reader.readBool(offsets[4]);
  object.text = reader.readStringOrNull(offsets[5]);
  return object;
}

P _isarTextSegmentDeserializeProp<P>(
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
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarTextSegmentQueryFilter
    on QueryBuilder<IsarTextSegment, IsarTextSegment, QFilterCondition> {
  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      colorValueEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      isBoldEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isBold',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      isHeadingEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isHeading',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      isItalicEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isItalic',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'text',
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
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

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'text',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'text',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'text',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarTextSegment, IsarTextSegment, QAfterFilterCondition>
      textIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'text',
        value: '',
      ));
    });
  }
}

extension IsarTextSegmentQueryObject
    on QueryBuilder<IsarTextSegment, IsarTextSegment, QFilterCondition> {}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarStrokeSchema = Schema(
  name: r'IsarStroke',
  id: -2749912407320495654,
  properties: {
    r'colorValue': PropertySchema(
      id: 0,
      name: r'colorValue',
      type: IsarType.long,
    ),
    r'points': PropertySchema(
      id: 1,
      name: r'points',
      type: IsarType.objectList,
      target: r'IsarPoint',
    ),
    r'pressures': PropertySchema(
      id: 2,
      name: r'pressures',
      type: IsarType.doubleList,
    ),
    r'width': PropertySchema(
      id: 3,
      name: r'width',
      type: IsarType.double,
    )
  },
  estimateSize: _isarStrokeEstimateSize,
  serialize: _isarStrokeSerialize,
  deserialize: _isarStrokeDeserialize,
  deserializeProp: _isarStrokeDeserializeProp,
);

int _isarStrokeEstimateSize(
  IsarStroke object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.points.length * 3;
  {
    final offsets = allOffsets[IsarPoint]!;
    for (var i = 0; i < object.points.length; i++) {
      final value = object.points[i];
      bytesCount += IsarPointSchema.estimateSize(value, offsets, allOffsets);
    }
  }
  bytesCount += 3 + object.pressures.length * 8;
  return bytesCount;
}

void _isarStrokeSerialize(
  IsarStroke object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.colorValue);
  writer.writeObjectList<IsarPoint>(
    offsets[1],
    allOffsets,
    IsarPointSchema.serialize,
    object.points,
  );
  writer.writeDoubleList(offsets[2], object.pressures);
  writer.writeDouble(offsets[3], object.width);
}

IsarStroke _isarStrokeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarStroke();
  object.colorValue = reader.readLong(offsets[0]);
  object.points = reader.readObjectList<IsarPoint>(
        offsets[1],
        IsarPointSchema.deserialize,
        allOffsets,
        IsarPoint(),
      ) ??
      [];
  object.pressures = reader.readDoubleList(offsets[2]) ?? [];
  object.width = reader.readDouble(offsets[3]);
  return object;
}

P _isarStrokeDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readObjectList<IsarPoint>(
            offset,
            IsarPointSchema.deserialize,
            allOffsets,
            IsarPoint(),
          ) ??
          []) as P;
    case 2:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

extension IsarStrokeQueryFilter
    on QueryBuilder<IsarStroke, IsarStroke, QFilterCondition> {
  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> colorValueEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      colorValueGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      colorValueLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'colorValue',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> colorValueBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'colorValue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      pointsLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> pointsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      pointsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      pointsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      pointsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
      pointsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'points',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition>
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

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> widthEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> widthGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> widthLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'width',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> widthBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'width',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension IsarStrokeQueryObject
    on QueryBuilder<IsarStroke, IsarStroke, QFilterCondition> {
  QueryBuilder<IsarStroke, IsarStroke, QAfterFilterCondition> pointsElement(
      FilterQuery<IsarPoint> q) {
    return QueryBuilder.apply(this, (query) {
      return query.object(q, r'points');
    });
  }
}

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

const IsarPointSchema = Schema(
  name: r'IsarPoint',
  id: -4063623505548704747,
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
  estimateSize: _isarPointEstimateSize,
  serialize: _isarPointSerialize,
  deserialize: _isarPointDeserialize,
  deserializeProp: _isarPointDeserializeProp,
);

int _isarPointEstimateSize(
  IsarPoint object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _isarPointSerialize(
  IsarPoint object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.x);
  writer.writeDouble(offsets[1], object.y);
}

IsarPoint _isarPointDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarPoint();
  object.x = reader.readDouble(offsets[0]);
  object.y = reader.readDouble(offsets[1]);
  return object;
}

P _isarPointDeserializeProp<P>(
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

extension IsarPointQueryFilter
    on QueryBuilder<IsarPoint, IsarPoint, QFilterCondition> {
  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> xEqualTo(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> xGreaterThan(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> xLessThan(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> xBetween(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> yEqualTo(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> yGreaterThan(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> yLessThan(
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

  QueryBuilder<IsarPoint, IsarPoint, QAfterFilterCondition> yBetween(
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

extension IsarPointQueryObject
    on QueryBuilder<IsarPoint, IsarPoint, QFilterCondition> {}
