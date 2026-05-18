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
    if (pluginState.enabled) {
      _requestCurrentFix();
    }
  }

  Future<void> setEnabled(bool enabled) async {
    final newState = enabled
        ? await bg.BackgroundGeolocation.start()
        : await bg.BackgroundGeolocation.stop();
    state = newState.enabled;
    if (newState.enabled) {
      _requestCurrentFix();
    }
  }

  /// Nudge the plugin to acquire a fix right now instead of waiting for a
  /// movement-triggered one. The result is delivered through the
  /// `onLocation` callback that `trackPointsProvider` already listens to,
  /// so we deliberately don't await the returned `Location` here.
  void _requestCurrentFix() {
    unawaited(bg.BackgroundGeolocation.getCurrentPosition());
  }
}

final trackingEnabledProvider =
    NotifierProvider<TrackingNotifier, bool>(TrackingNotifier.new);
