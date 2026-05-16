// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_settings_model.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetIsarAppSettingsCollection on Isar {
  IsarCollection<IsarAppSettings> get isarAppSettings => this.collection();
}

const IsarAppSettingsSchema = CollectionSchema(
  name: r'IsarAppSettings',
  id: -9223260734181630302,
  properties: {
    r'isPinSet': PropertySchema(
      id: 0,
      name: r'isPinSet',
      type: IsarType.bool,
    ),
    r'masterPinHash': PropertySchema(
      id: 1,
      name: r'masterPinHash',
      type: IsarType.string,
    ),
    r'relockLogic': PropertySchema(
      id: 2,
      name: r'relockLogic',
      type: IsarType.long,
    )
  },
  estimateSize: _isarAppSettingsEstimateSize,
  serialize: _isarAppSettingsSerialize,
  deserialize: _isarAppSettingsDeserialize,
  deserializeProp: _isarAppSettingsDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _isarAppSettingsGetId,
  getLinks: _isarAppSettingsGetLinks,
  attach: _isarAppSettingsAttach,
  version: '3.1.0+1',
);

int _isarAppSettingsEstimateSize(
  IsarAppSettings object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.masterPinHash;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _isarAppSettingsSerialize(
  IsarAppSettings object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeBool(offsets[0], object.isPinSet);
  writer.writeString(offsets[1], object.masterPinHash);
  writer.writeLong(offsets[2], object.relockLogic);
}

IsarAppSettings _isarAppSettingsDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = IsarAppSettings();
  object.id = id;
  object.masterPinHash = reader.readStringOrNull(offsets[1]);
  object.relockLogic = reader.readLong(offsets[2]);
  return object;
}

P _isarAppSettingsDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readBool(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _isarAppSettingsGetId(IsarAppSettings object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _isarAppSettingsGetLinks(IsarAppSettings object) {
  return [];
}

void _isarAppSettingsAttach(
    IsarCollection<dynamic> col, Id id, IsarAppSettings object) {
  object.id = id;
}

extension IsarAppSettingsQueryWhereSort
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QWhere> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension IsarAppSettingsQueryWhere
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QWhereClause> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhereClause>
      idNotEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarAppSettingsQueryFilter
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QFilterCondition> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      isPinSetEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPinSet',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'masterPinHash',
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'masterPinHash',
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'masterPinHash',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'masterPinHash',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'masterPinHash',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'masterPinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      masterPinHashIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'masterPinHash',
        value: '',
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      relockLogicEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relockLogic',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      relockLogicGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relockLogic',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      relockLogicLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relockLogic',
        value: value,
      ));
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterFilterCondition>
      relockLogicBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relockLogic',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension IsarAppSettingsQueryObject
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QFilterCondition> {}

extension IsarAppSettingsQueryLinks
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QFilterCondition> {}

extension IsarAppSettingsQuerySortBy
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QSortBy> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByIsPinSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinSet', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByIsPinSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinSet', Sort.desc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByMasterPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterPinHash', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByMasterPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterPinHash', Sort.desc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByRelockLogic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relockLogic', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      sortByRelockLogicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relockLogic', Sort.desc);
    });
  }
}

extension IsarAppSettingsQuerySortThenBy
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QSortThenBy> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByIsPinSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinSet', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByIsPinSetDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPinSet', Sort.desc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByMasterPinHash() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterPinHash', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByMasterPinHashDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'masterPinHash', Sort.desc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByRelockLogic() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relockLogic', Sort.asc);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QAfterSortBy>
      thenByRelockLogicDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relockLogic', Sort.desc);
    });
  }
}

extension IsarAppSettingsQueryWhereDistinct
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QDistinct> {
  QueryBuilder<IsarAppSettings, IsarAppSettings, QDistinct>
      distinctByIsPinSet() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPinSet');
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QDistinct>
      distinctByMasterPinHash({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'masterPinHash',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<IsarAppSettings, IsarAppSettings, QDistinct>
      distinctByRelockLogic() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relockLogic');
    });
  }
}

extension IsarAppSettingsQueryProperty
    on QueryBuilder<IsarAppSettings, IsarAppSettings, QQueryProperty> {
  QueryBuilder<IsarAppSettings, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<IsarAppSettings, bool, QQueryOperations> isPinSetProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPinSet');
    });
  }

  QueryBuilder<IsarAppSettings, String?, QQueryOperations>
      masterPinHashProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'masterPinHash');
    });
  }

  QueryBuilder<IsarAppSettings, int, QQueryOperations> relockLogicProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relockLogic');
    });
  }
}
