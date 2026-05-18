import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

part 'database.g.dart';

class LocationPoints extends Table {
  IntColumn get id => integer().autoIncrement()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  RealColumn get accuracyMeters => real()();
  DateTimeColumn get recordedAt => dateTime()();
  RealColumn get speedMetersPerSecond => real().nullable()();
  RealColumn get altitudeMeters => real().nullable()();
  RealColumn get headingDegrees => real().nullable()();
  TextColumn get activity => text().nullable()();
}

@DriftDatabase(tables: [LocationPoints])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<int> insertPoint({
    required double latitude,
    required double longitude,
    required double accuracyMeters,
    required DateTime recordedAt,
    double? speedMetersPerSecond,
    double? altitudeMeters,
    double? headingDegrees,
    String? activity,
  }) {
    return into(locationPoints).insert(
      LocationPointsCompanion.insert(
        latitude: latitude,
        longitude: longitude,
        accuracyMeters: accuracyMeters,
        recordedAt: recordedAt,
        speedMetersPerSecond: Value(speedMetersPerSecond),
        altitudeMeters: Value(altitudeMeters),
        headingDegrees: Value(headingDegrees),
        activity: Value(activity),
      ),
    );
  }

  Stream<List<LocationPoint>> watchAllPoints() {
    return (select(locationPoints)
          ..orderBy([(t) => OrderingTerm.asc(t.recordedAt)]))
        .watch();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'location_tracker.sqlite'));
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }
    return NativeDatabase.createInBackground(file);
  });
}

final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});
