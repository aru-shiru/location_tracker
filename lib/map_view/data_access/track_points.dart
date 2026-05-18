import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

/// The ordered series of LatLng points recorded since app start.
///
/// Subscribes to `flutter_background_geolocation.onLocation` and appends
/// each fix to the in-memory list. Tracking has to be running for any
/// points to arrive — the plugin only emits while the foreground service
/// is started.
///
/// Points are not persisted yet, so they don't survive an app kill;
/// drift-backed storage is the next layer.
class TrackPointsNotifier extends Notifier<List<LatLng>> {
  @override
  List<LatLng> build() {
    bg.BackgroundGeolocation.onLocation((bg.Location location) {
      state = [
        ...state,
        LatLng(location.coords.latitude, location.coords.longitude),
      ];
    });
    return const [];
  }
}

final trackPointsProvider =
    NotifierProvider<TrackPointsNotifier, List<LatLng>>(
  TrackPointsNotifier.new,
);
