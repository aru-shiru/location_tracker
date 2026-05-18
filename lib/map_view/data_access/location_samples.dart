import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../shared/shared.dart';
import 'models/location_sample.dart';

/// The ordered series of location fixes ever recorded for this install.
///
/// Subscribes to `flutter_background_geolocation.onLocation` and persists
/// each [LocationSample] to drift. The exposed `List<LocationSample>` is
/// re-emitted from `db.watchAllPoints()`, so the same provider feeds both
/// "new fixes coming in right now" and "fixes recorded in a previous app
/// run" — surviving process kills and reboots.
class LocationSamplesNotifier extends Notifier<List<LocationSample>> {
  @override
  List<LocationSample> build() {
    final db = ref.read(databaseProvider);

    // Stream the full history from drift; the first emission replays
    // everything persisted from previous app runs, subsequent emissions
    // include each newly inserted fix.
    final sub = db.watchAllPoints().listen((rows) {
      state = [for (final r in rows) _rowToSample(r)];
    });
    ref.onDispose(sub.cancel);

    // Persist every incoming fix; the watcher above picks the row up.
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      final sample = _toSample(location);
      db.insertPoint(
        latitude: sample.latLng.latitude,
        longitude: sample.latLng.longitude,
        accuracyMeters: sample.accuracyMeters,
        recordedAt: sample.recordedAt,
        speedMetersPerSecond: sample.speedMetersPerSecond,
        altitudeMeters: sample.altitudeMeters,
        headingDegrees: sample.headingDegrees,
        activity: sample.activity,
      );
    });

    return const [];
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
