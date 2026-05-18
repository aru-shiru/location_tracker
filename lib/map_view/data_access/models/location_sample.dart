import 'package:latlong2/latlong.dart';

/// One location fix recorded by the tracker. Holds everything the UI
/// needs to render — latitude/longitude for the map, plus accuracy,
/// speed, altitude, heading, motion activity, and timestamp for the
/// status sheet. Nullable fields are `null` when the platform reports
/// the value as unknown (the plugin uses sentinels like `-1` natively;
/// the notifier sanitizes those on the way in).
class LocationSample {
  const LocationSample({
    required this.latLng,
    required this.accuracyMeters,
    required this.recordedAt,
    this.speedMetersPerSecond,
    this.altitudeMeters,
    this.headingDegrees,
    this.activity,
  });

  final LatLng latLng;
  final double accuracyMeters;
  final DateTime recordedAt;
  final double? speedMetersPerSecond;
  final double? altitudeMeters;
  final double? headingDegrees;
  final String? activity;
}
