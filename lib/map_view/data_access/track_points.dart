import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// The ordered series of recorded location points to draw on the map.
///
/// Currently emits a hard-coded dummy track around Bundaran HI, Jakarta so
/// the screen can wire to a provider before the real source exists. Will
/// be replaced with a stream-backed provider once
/// `flutter_background_geolocation` is wired up and the points are
/// persisted to drift.
final trackPointsProvider = Provider<List<LatLng>>((ref) {
  return const [
    LatLng(-6.20210, 106.84610),
    LatLng(-6.20170, 106.84595),
    LatLng(-6.20130, 106.84580),
    LatLng(-6.20100, 106.84570),
    LatLng(-6.20088, 106.84559),
  ];
});
