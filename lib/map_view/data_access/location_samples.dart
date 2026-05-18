import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../shared/shared.dart';
import 'models/location_sample.dart';

/// The ordered series of location fixes ever recorded for this install.
///
/// Persists every fix to drift so the recorded track survives an app
/// kill. Two paths feed drift:
///
/// 1. **Live path** — `onLocation` is invoked while the Dart isolate is
///    alive. We insert and then clear the plugin's internal queue so it
///    doesn't double up.
/// 2. **Drain path** — on cold start we read whatever the plugin's
///    native side captured while we were terminated (it keeps recording
///    via the foreground service) and write those rows into drift too.
///
/// The exposed `List<LocationSample>` is re-emitted from
/// `db.watchAllPoints()`, so consumers see one merged history.
class LocationSamplesNotifier extends Notifier<List<LocationSample>> {
  @override
  List<LocationSample> build() {
    final db = ref.read(databaseProvider);

    final sub = db.watchAllPoints().listen((rows) {
      state = [for (final r in rows) _rowToSample(r)];
    });
    ref.onDispose(sub.cancel);

    // Bring in anything captured while our isolate was dead.
    unawaited(_drainPluginQueue(db));

    bg.BackgroundGeolocation.onLocation((bg.Location location) async {
      await _persist(db, _toSample(location));
      // Keep the plugin's queue empty during the alive period; without
      // this, the next cold-start drain would re-ingest fixes we
      // already wrote through this path.
      await bg.BackgroundGeolocation.destroyLocations();
    });

    return const [];
  }

  Future<void> _drainPluginQueue(AppDatabase db) async {
    final queued = await bg.BackgroundGeolocation.locations;
    for (final raw in queued) {
      final location = bg.Location(raw as Map);
      await _persist(db, _toSample(location));
    }
    if (queued.isNotEmpty) {
      await bg.BackgroundGeolocation.destroyLocations();
    }
  }

  Future<int> _persist(AppDatabase db, LocationSample sample) {
    return db.insertPoint(
      latitude: sample.latLng.latitude,
      longitude: sample.latLng.longitude,
      accuracyMeters: sample.accuracyMeters,
      recordedAt: sample.recordedAt,
      speedMetersPerSecond: sample.speedMetersPerSecond,
      altitudeMeters: sample.altitudeMeters,
      headingDegrees: sample.headingDegrees,
      activity: sample.activity,
    );
  }

  /// Plugin → domain. Negative values are the plugin's "unknown" sentinel
  /// for `speed`, `altitude`, and `heading`; map them to `null` so the
  /// UI can render a clean placeholder instead of "−1 m".
  LocationSample _toSample(bg.Location location) {
    double? sanitize(num value) => value < 0 ? null : value.toDouble();
    return LocationSample(
      latLng: LatLng(location.coords.latitude, location.coords.longitude),
      accuracyMeters: location.coords.accuracy,
      recordedAt:
          DateTime.tryParse(location.timestamp) ?? DateTime.now(),
      speedMetersPerSecond: sanitize(location.coords.speed),
      altitudeMeters: sanitize(location.coords.altitude),
      headingDegrees: sanitize(location.coords.heading),
      activity: location.activity.type,
    );
  }

  LocationSample _rowToSample(LocationPoint row) {
    return LocationSample(
      latLng: LatLng(row.latitude, row.longitude),
      accuracyMeters: row.accuracyMeters,
      recordedAt: row.recordedAt,
      speedMetersPerSecond: row.speedMetersPerSecond,
      altitudeMeters: row.altitudeMeters,
      headingDegrees: row.headingDegrees,
      activity: row.activity,
    );
  }
}

final locationSamplesProvider =
    NotifierProvider<LocationSamplesNotifier, List<LocationSample>>(
  LocationSamplesNotifier.new,
);
