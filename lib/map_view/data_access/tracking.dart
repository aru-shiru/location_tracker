import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingNotifier extends Notifier<bool> {
  @override
  bool build() {
    unawaited(_syncFromPlugin());
    return false;
  }

  /// Pull the plugin's current `enabled` state into the notifier on first
  /// build. The plugin remembers whether tracking was running across app
  /// launches, so a relaunch should reflect the real native state rather
  /// than the local default.
  Future<void> _syncFromPlugin() async {
    final pluginState = await bg.BackgroundGeolocation.state;
    state = pluginState.enabled;
  }

  Future<void> setEnabled(bool enabled) async {
    final newState = enabled
        ? await bg.BackgroundGeolocation.start()
        : await bg.BackgroundGeolocation.stop();
    state = newState.enabled;
  }
}

final trackingEnabledProvider =
    NotifierProvider<TrackingNotifier, bool>(TrackingNotifier.new);
