import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import 'models/location_sample.dart';

/// The ordered series of location fixes recorded since app start.
///
/// Subscribes to `flutter_background_geolocation.onLocation` and appends
/// a [LocationSample] (lat/lng plus accuracy, speed, altitude, heading,
/// motion activity, and timestamp) for each incoming fix. Tracking has
/// to be running for any points to arrive — the plugin only emits while
/// the foreground service is started.
///
/// In-memory only for now; points do not survive an app kill.
class LocationSamplesNotifier extends Notifier<List<LocationSample>> {
  @override
  List<LocationSample> build() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      state = [...state, _toSample(location)];
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
}

final locationSamplesProvider =
    NotifierProvider<LocationSamplesNotifier, List<LocationSample>>(
  LocationSamplesNotifier.new,
);
