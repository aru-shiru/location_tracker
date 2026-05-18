// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $LocationPointsTable extends LocationPoints
    with TableInfo<$LocationPointsTable, LocationPoint> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $LocationPointsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _latitudeMeta = const VerificationMeta(
    'latitude',
  );
  @override
  late final GeneratedColumn<double> latitude = GeneratedColumn<double>(
    'latitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _longitudeMeta = const VerificationMeta(
    'longitude',
  );
  @override
  late final GeneratedColumn<double> longitude = GeneratedColumn<double>(
    'longitude',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accuracyMetersMeta = const VerificationMeta(
    'accuracyMeters',
  );
  @override
  late final GeneratedColumn<double> accuracyMeters = GeneratedColumn<double>(
    'accuracy_meters',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recordedAtMeta = const VerificationMeta(
    'recordedAt',
  );
  @override
  late final GeneratedColumn<DateTime> recordedAt = GeneratedColumn<DateTime>(
    'recorded_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _speedMetersPerSecondMeta =
      const VerificationMeta('speedMetersPerSecond');
  @override
  late final GeneratedColumn<double> speedMetersPerSecond =
      GeneratedColumn<double>(
        'speed_meters_per_second',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _altitudeMetersMeta = const VerificationMeta(
    'altitudeMeters',
  );
  @override
  late final GeneratedColumn<double> altitudeMeters = GeneratedColumn<double>(
    'altitude_meters',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _headingDegreesMeta = const VerificationMeta(
    'headingDegrees',
  );
  @override
  late final GeneratedColumn<double> headingDegrees = GeneratedColumn<double>(
    'heading_degrees',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activityMeta = const VerificationMeta(
    'activity',
  );
  @override
  late final GeneratedColumn<String> activity = GeneratedColumn<String>(
    'activity',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
    speedMetersPerSecond,
    altitudeMeters,
    headingDegrees,
    activity,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'location_points';
  @override
  VerificationContext validateIntegrity(
    Insertable<LocationPoint> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('latitude')) {
      context.handle(
        _latitudeMeta,
        latitude.isAcceptableOrUnknown(data['latitude']!, _latitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_latitudeMeta);
    }
    if (data.containsKey('longitude')) {
      context.handle(
        _longitudeMeta,
        longitude.isAcceptableOrUnknown(data['longitude']!, _longitudeMeta),
      );
    } else if (isInserting) {
      context.missing(_longitudeMeta);
    }
    if (data.containsKey('accuracy_meters')) {
      context.handle(
        _accuracyMetersMeta,
        accuracyMeters.isAcceptableOrUnknown(
          data['accuracy_meters']!,
          _accuracyMetersMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_accuracyMetersMeta);
    }
    if (data.containsKey('recorded_at')) {
      context.handle(
        _recordedAtMeta,
        recordedAt.isAcceptableOrUnknown(data['recorded_at']!, _recordedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_recordedAtMeta);
    }
    if (data.containsKey('speed_meters_per_second')) {
      context.handle(
        _speedMetersPerSecondMeta,
        speedMetersPerSecond.isAcceptableOrUnknown(
          data['speed_meters_per_second']!,
          _speedMetersPerSecondMeta,
        ),
      );
    }
    if (data.containsKey('altitude_meters')) {
      context.handle(
        _altitudeMetersMeta,
        altitudeMeters.isAcceptableOrUnknown(
          data['altitude_meters']!,
          _altitudeMetersMeta,
        ),
      );
    }
    if (data.containsKey('heading_degrees')) {
      context.handle(
        _headingDegreesMeta,
        headingDegrees.isAcceptableOrUnknown(
          data['heading_degrees']!,
          _headingDegreesMeta,
        ),
      );
    }
    if (data.containsKey('activity')) {
      context.handle(
        _activityMeta,
        activity.isAcceptableOrUnknown(data['activity']!, _activityMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  LocationPoint map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return LocationPoint(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      latitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}latitude'],
      )!,
      longitude: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}longitude'],
      )!,
      accuracyMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}accuracy_meters'],
      )!,
      recordedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}recorded_at'],
      )!,
      speedMetersPerSecond: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}speed_meters_per_second'],
      ),
      altitudeMeters: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}altitude_meters'],
      ),
      headingDegrees: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}heading_degrees'],
      ),
      activity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity'],
      ),
    );
  }

  @override
  $LocationPointsTable createAlias(String alias) {
    return $LocationPointsTable(attachedDatabase, alias);
  }
}

class LocationPoint extends DataClass implements Insertable<LocationPoint> {
  final int id;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final DateTime recordedAt;
  final double? speedMetersPerSecond;
  final double? altitudeMeters;
  final double? headingDegrees;
  final String? activity;
  const LocationPoint({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.recordedAt,
    this.speedMetersPerSecond,
    this.altitudeMeters,
    this.headingDegrees,
    this.activity,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['latitude'] = Variable<double>(latitude);
    map['longitude'] = Variable<double>(longitude);
    map['accuracy_meters'] = Variable<double>(accuracyMeters);
    map['recorded_at'] = Variable<DateTime>(recordedAt);
    if (!nullToAbsent || speedMetersPerSecond != null) {
      map['speed_meters_per_second'] = Variable<double>(speedMetersPerSecond);
    }
    if (!nullToAbsent || altitudeMeters != null) {
      map['altitude_meters'] = Variable<double>(altitudeMeters);
    }
    if (!nullToAbsent || headingDegrees != null) {
      map['heading_degrees'] = Variable<double>(headingDegrees);
    }
    if (!nullToAbsent || activity != null) {
      map['activity'] = Variable<String>(activity);
    }
    return map;
  }

  LocationPointsCompanion toCompanion(bool nullToAbsent) {
    return LocationPointsCompanion(
      id: Value(id),
      latitude: Value(latitude),
      longitude: Value(longitude),
      accuracyMeters: Value(accuracyMeters),
      recordedAt: Value(recordedAt),
      speedMetersPerSecond: speedMetersPerSecond == null && nullToAbsent
          ? const Value.absent()
          : Value(speedMetersPerSecond),
      altitudeMeters: altitudeMeters == null && nullToAbsent
          ? const Value.absent()
          : Value(altitudeMeters),
      headingDegrees: headingDegrees == null && nullToAbsent
          ? const Value.absent()
          : Value(headingDegrees),
      activity: activity == null && nullToAbsent
          ? const Value.absent()
          : Value(activity),
    );
  }

  factory LocationPoint.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return LocationPoint(
      id: serializer.fromJson<int>(json['id']),
      latitude: serializer.fromJson<double>(json['latitude']),
      longitude: serializer.fromJson<double>(json['longitude']),
      accuracyMeters: serializer.fromJson<double>(json['accuracyMeters']),
      recordedAt: serializer.fromJson<DateTime>(json['recordedAt']),
      speedMetersPerSecond: serializer.fromJson<double?>(
        json['speedMetersPerSecond'],
      ),
      altitudeMeters: serializer.fromJson<double?>(json['altitudeMeters']),
      headingDegrees: serializer.fromJson<double?>(json['headingDegrees']),
      activity: serializer.fromJson<String?>(json['activity']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'latitude': serializer.toJson<double>(latitude),
      'longitude': serializer.toJson<double>(longitude),
      'accuracyMeters': serializer.toJson<double>(accuracyMeters),
      'recordedAt': serializer.toJson<DateTime>(recordedAt),
      'speedMetersPerSecond': serializer.toJson<double?>(speedMetersPerSecond),
      'altitudeMeters': serializer.toJson<double?>(altitudeMeters),
      'headingDegrees': serializer.toJson<double?>(headingDegrees),
      'activity': serializer.toJson<String?>(activity),
    };
  }

  LocationPoint copyWith({
    int? id,
    double? latitude,
    double? longitude,
    double? accuracyMeters,
    DateTime? recordedAt,
    Value<double?> speedMetersPerSecond = const Value.absent(),
    Value<double?> altitudeMeters = const Value.absent(),
    Value<double?> headingDegrees = const Value.absent(),
    Value<String?> activity = const Value.absent(),
  }) => LocationPoint(
    id: id ?? this.id,
    latitude: latitude ?? this.latitude,
    longitude: longitude ?? this.longitude,
    accuracyMeters: accuracyMeters ?? this.accuracyMeters,
    recordedAt: recordedAt ?? this.recordedAt,
    speedMetersPerSecond: speedMetersPerSecond.present
        ? speedMetersPerSecond.value
        : this.speedMetersPerSecond,
    altitudeMeters: altitudeMeters.present
        ? altitudeMeters.value
        : this.altitudeMeters,
    headingDegrees: headingDegrees.present
        ? headingDegrees.value
        : this.headingDegrees,
    activity: activity.present ? activity.value : this.activity,
  );
  LocationPoint copyWithCompanion(LocationPointsCompanion data) {
    return LocationPoint(
      id: data.id.present ? data.id.value : this.id,
      latitude: data.latitude.present ? data.latitude.value : this.latitude,
      longitude: data.longitude.present ? data.longitude.value : this.longitude,
      accuracyMeters: data.accuracyMeters.present
          ? data.accuracyMeters.value
          : this.accuracyMeters,
      recordedAt: data.recordedAt.present
          ? data.recordedAt.value
          : this.recordedAt,
      speedMetersPerSecond: data.speedMetersPerSecond.present
          ? data.speedMetersPerSecond.value
          : this.speedMetersPerSecond,
      altitudeMeters: data.altitudeMeters.present
          ? data.altitudeMeters.value
          : this.altitudeMeters,
      headingDegrees: data.headingDegrees.present
          ? data.headingDegrees.value
          : this.headingDegrees,
      activity: data.activity.present ? data.activity.value : this.activity,
    );
  }

  @override
  String toString() {
    return (StringBuffer('LocationPoint(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('speedMetersPerSecond: $speedMetersPerSecond, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('headingDegrees: $headingDegrees, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    latitude,
    longitude,
    accuracyMeters,
    recordedAt,
    speedMetersPerSecond,
    altitudeMeters,
    headingDegrees,
    activity,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is LocationPoint &&
          other.id == this.id &&
          other.latitude == this.latitude &&
          other.longitude == this.longitude &&
          other.accuracyMeters == this.accuracyMeters &&
          other.recordedAt == this.recordedAt &&
          other.speedMetersPerSecond == this.speedMetersPerSecond &&
          other.altitudeMeters == this.altitudeMeters &&
          other.headingDegrees == this.headingDegrees &&
          other.activity == this.activity);
}

class LocationPointsCompanion extends UpdateCompanion<LocationPoint> {
  final Value<int> id;
  final Value<double> latitude;
  final Value<double> longitude;
  final Value<double> accuracyMeters;
  final Value<DateTime> recordedAt;
  final Value<double?> speedMetersPerSecond;
  final Value<double?> altitudeMeters;
  final Value<double?> headingDegrees;
  final Value<String?> activity;
  const LocationPointsCompanion({
    this.id = const Value.absent(),
    this.latitude = const Value.absent(),
    this.longitude = const Value.absent(),
    this.accuracyMeters = const Value.absent(),
    this.recordedAt = const Value.absent(),
    this.speedMetersPerSecond = const Value.absent(),
    this.altitudeMeters = const Value.absent(),
    this.headingDegrees = const Value.absent(),
    this.activity = const Value.absent(),
  });
  LocationPointsCompanion.insert({
    this.id = const Value.absent(),
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required DateTime recordedAt,
    this.speedMetersPerSecond = const Value.absent(),
    this.altitudeMeters = const Value.absent(),
    this.headingDegrees = const Value.absent(),
    this.activity = const Value.absent(),
  }) : latitude = Value(latitude),
       longitude = Value(longitude),
       accuracyMeters = Value(accuracyMeters),
       recordedAt = Value(recordedAt);
  static Insertable<LocationPoint> custom({
    Expression<int>? id,
    Expression<double>? latitude,
    Expression<double>? longitude,
    Expression<double>? accuracyMeters,
    Expression<DateTime>? recordedAt,
    Expression<double>? speedMetersPerSecond,
    Expression<double>? altitudeMeters,
    Expression<double>? headingDegrees,
    Expression<String>? activity,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (latitude != null) 'latitude': latitude,
      if (longitude != null) 'longitude': longitude,
      if (accuracyMeters != null) 'accuracy_meters': accuracyMeters,
      if (recordedAt != null) 'recorded_at': recordedAt,
      if (speedMetersPerSecond != null)
        'speed_meters_per_second': speedMetersPerSecond,
      if (altitudeMeters != null) 'altitude_meters': altitudeMeters,
      if (headingDegrees != null) 'heading_degrees': headingDegrees,
      if (activity != null) 'activity': activity,
    });
  }

  LocationPointsCompanion copyWith({
    Value<int>? id,
    Value<double>? latitude,
    Value<double>? longitude,
    Value<double>? accuracyMeters,
    Value<DateTime>? recordedAt,
    Value<double?>? speedMetersPerSecond,
    Value<double?>? altitudeMeters,
    Value<double?>? headingDegrees,
    Value<String?>? activity,
  }) {
    return LocationPointsCompanion(
      id: id ?? this.id,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      accuracyMeters: accuracyMeters ?? this.accuracyMeters,
      recordedAt: recordedAt ?? this.recordedAt,
      speedMetersPerSecond: speedMetersPerSecond ?? this.speedMetersPerSecond,
      altitudeMeters: altitudeMeters ?? this.altitudeMeters,
      headingDegrees: headingDegrees ?? this.headingDegrees,
      activity: activity ?? this.activity,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (latitude.present) {
      map['latitude'] = Variable<double>(latitude.value);
    }
    if (longitude.present) {
      map['longitude'] = Variable<double>(longitude.value);
    }
    if (accuracyMeters.present) {
      map['accuracy_meters'] = Variable<double>(accuracyMeters.value);
    }
    if (recordedAt.present) {
      map['recorded_at'] = Variable<DateTime>(recordedAt.value);
    }
    if (speedMetersPerSecond.present) {
      map['speed_meters_per_second'] = Variable<double>(
        speedMetersPerSecond.value,
      );
    }
    if (altitudeMeters.present) {
      map['altitude_meters'] = Variable<double>(altitudeMeters.value);
    }
    if (headingDegrees.present) {
      map['heading_degrees'] = Variable<double>(headingDegrees.value);
    }
    if (activity.present) {
      map['activity'] = Variable<String>(activity.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('LocationPointsCompanion(')
          ..write('id: $id, ')
          ..write('latitude: $latitude, ')
          ..write('longitude: $longitude, ')
          ..write('accuracyMeters: $accuracyMeters, ')
          ..write('recordedAt: $recordedAt, ')
          ..write('speedMetersPerSecond: $speedMetersPerSecond, ')
          ..write('altitudeMeters: $altitudeMeters, ')
          ..write('headingDegrees: $headingDegrees, ')
          ..write('activity: $activity')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $LocationPointsTable locationPoints = $LocationPointsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [locationPoints];
}

typedef $$LocationPointsTableCreateCompanionBuilder =
    LocationPointsCompanion Function({
      Value<int> id,
      required double latitude,
      required double longitude,
      required double accuracyMeters,
      required DateTime recordedAt,
      Value<double?> speedMetersPerSecond,
      Value<double?> altitudeMeters,
      Value<double?> headingDegrees,
      Value<String?> activity,
    });
typedef $$LocationPointsTableUpdateCompanionBuilder =
    LocationPointsCompanion Function({
      Value<int> id,
      Value<double> latitude,
      Value<double> longitude,
      Value<double> accuracyMeters,
      Value<DateTime> recordedAt,
      Value<double?> speedMetersPerSecond,
      Value<double?> altitudeMeters,
      Value<double?> headingDegrees,
      Value<String?> activity,
    });

class $$LocationPointsTableFilterComposer
    extends Composer<_$AppDatabase, $LocationPointsTable> {
  $$LocationPointsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get headingDegrees => $composableBuilder(
    column: $table.headingDegrees,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnFilters(column),
  );
}

class $$LocationPointsTableOrderingComposer
    extends Composer<_$AppDatabase, $LocationPointsTable> {
  $$LocationPointsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get latitude => $composableBuilder(
    column: $table.latitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get longitude => $composableBuilder(
    column: $table.longitude,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get headingDegrees => $composableBuilder(
    column: $table.headingDegrees,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activity => $composableBuilder(
    column: $table.activity,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$LocationPointsTableAnnotationComposer
    extends Composer<_$AppDatabase, $LocationPointsTable> {
  $$LocationPointsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<double> get latitude =>
      $composableBuilder(column: $table.latitude, builder: (column) => column);

  GeneratedColumn<double> get longitude =>
      $composableBuilder(column: $table.longitude, builder: (column) => column);

  GeneratedColumn<double> get accuracyMeters => $composableBuilder(
    column: $table.accuracyMeters,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get recordedAt => $composableBuilder(
    column: $table.recordedAt,
    builder: (column) => column,
  );

  GeneratedColumn<double> get speedMetersPerSecond => $composableBuilder(
    column: $table.speedMetersPerSecond,
    builder: (column) => column,
  );

  GeneratedColumn<double> get altitudeMeters => $composableBuilder(
    column: $table.altitudeMeters,
    builder: (column) => column,
  );

  GeneratedColumn<double> get headingDegrees => $composableBuilder(
    column: $table.headingDegrees,
    builder: (column) => column,
  );

  GeneratedColumn<String> get activity =>
      $composableBuilder(column: $table.activity, builder: (column) => column);
}

class $$LocationPointsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $LocationPointsTable,
          LocationPoint,
          $$LocationPointsTableFilterComposer,
          $$LocationPointsTableOrderingComposer,
          $$LocationPointsTableAnnotationComposer,
          $$LocationPointsTableCreateCompanionBuilder,
          $$LocationPointsTableUpdateCompanionBuilder,
          (
            LocationPoint,
            BaseReferences<_$AppDatabase, $LocationPointsTable, LocationPoint>,
          ),
          LocationPoint,
          PrefetchHooks Function()
        > {
  $$LocationPointsTableTableManager(
    _$AppDatabase db,
    $LocationPointsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$LocationPointsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$LocationPointsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$LocationPointsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<double> latitude = const Value.absent(),
                Value<double> longitude = const Value.absent(),
                Value<double> accuracyMeters = const Value.absent(),
                Value<DateTime> recordedAt = const Value.absent(),
                Value<double?> speedMetersPerSecond = const Value.absent(),
                Value<double?> altitudeMeters = const Value.absent(),
                Value<double?> headingDegrees = const Value.absent(),
                Value<String?> activity = const Value.absent(),
              }) => LocationPointsCompanion(
                id: id,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
                speedMetersPerSecond: speedMetersPerSecond,
                altitudeMeters: altitudeMeters,
                headingDegrees: headingDegrees,
                activity: activity,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required double latitude,
                required double longitude,
                required double accuracyMeters,
                required DateTime recordedAt,
                Value<double?> speedMetersPerSecond = const Value.absent(),
                Value<double?> altitudeMeters = const Value.absent(),
                Value<double?> headingDegrees = const Value.absent(),
                Value<String?> activity = const Value.absent(),
              }) => LocationPointsCompanion.insert(
                id: id,
                latitude: latitude,
                longitude: longitude,
                accuracyMeters: accuracyMeters,
                recordedAt: recordedAt,
                speedMetersPerSecond: speedMetersPerSecond,
                altitudeMeters: altitudeMeters,
                headingDegrees: headingDegrees,
                activity: activity,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$LocationPointsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $LocationPointsTable,
      LocationPoint,
      $$LocationPointsTableFilterComposer,
      $$LocationPointsTableOrderingComposer,
      $$LocationPointsTableAnnotationComposer,
      $$LocationPointsTableCreateCompanionBuilder,
      $$LocationPointsTableUpdateCompanionBuilder,
      (
        LocationPoint,
        BaseReferences<_$AppDatabase, $LocationPointsTable, LocationPoint>,
      ),
      LocationPoint,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$LocationPointsTableTableManager get locationPoints =>
      $$LocationPointsTableTableManager(_db, _db.locationPoints);
}
