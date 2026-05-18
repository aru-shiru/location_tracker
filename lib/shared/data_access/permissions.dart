import 'dart:async';

import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart' as ph;

class Permissions {
  const Permissions({
    this.foreground = false,
    this.background = false,
    this.notifications = false,
  });

  final bool foreground;
  final bool background;
  final bool notifications;

  bool get allGranted => foreground && background && notifications;

  int get grantedCount =>
      (foreground ? 1 : 0) +
      (background ? 1 : 0) +
      (notifications ? 1 : 0);

  Permissions copyWith({
    bool? foreground,
    bool? background,
    bool? notifications,
  }) {
    return Permissions(
      foreground: foreground ?? this.foreground,
      background: background ?? this.background,
      notifications: notifications ?? this.notifications,
    );
  }
}

class PermissionsNotifier extends Notifier<Permissions> {
  @override
  Permissions build() {
    unawaited(_initialize());
    return const Permissions();
  }

  Future<void> _initialize() async {
    // 'WhenInUse' seeds the plugin's config so the first prompt asks for
    // foreground location only; requestNext() escalates to 'Always' when
    // the user reaches the background-location step.
    await bg.BackgroundGeolocation.ready(
      bg.Config(
        locationAuthorizationRequest: 'WhenInUse',
        stopOnTerminate: false,
        startOnBoot: true,
        notification: bg.Notification(
          title: 'Location Tracker',
          text: 'Recording your location in the background.',
          sticky: true,
        ),
        backgroundPermissionRationale: bg.PermissionRationale(
          title:
              "Allow {applicationName} to access this device's location even when closed or not in use?",
          message:
              'Location Tracker keeps recording your location while the app '
              'is in the background or closed, so your trip history stays '
              'accurate. You can change this anytime in Settings.',
          positiveAction: 'Change to "{backgroundPermissionOptionLabel}"',
          negativeAction: 'Cancel',
        ),
      ),
    );
    state = await _readCurrentStatus();
    // Reflect runtime permission changes (e.g. user toggles in Settings).
    bg.BackgroundGeolocation.onProviderChange((_) async {
      state = await _readCurrentStatus();
    });
  }

  Future<Permissions> _readCurrentStatus() async {
    final providerState = await bg.BackgroundGeolocation.providerState;
    final status = providerState.status;
    final foreground =
        status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_WHEN_IN_USE ||
            status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS;
    final background =
        status == bg.ProviderChangeEvent.AUTHORIZATION_STATUS_ALWAYS;
    final notifications = await ph.Permission.notification.isGranted;
    return Permissions(
      foreground: foreground,
      background: background,
      notifications: notifications,
    );
  }

  Future<void> requestNext() async {
    final current = state;
    if (!current.foreground) {
      await bg.BackgroundGeolocation.setConfig(
        bg.Config(locationAuthorizationRequest: 'WhenInUse'),
      );
      await bg.BackgroundGeolocation.requestPermission();
    } else if (!current.background) {
      await bg.BackgroundGeolocation.setConfig(
        bg.Config(locationAuthorizationRequest: 'Always'),
      );
      await bg.BackgroundGeolocation.requestPermission();
    } else if (!current.notifications) {
      await ph.Permission.notification.request();
    }
    state = await _readCurrentStatus();
  }
}

final permissionsProvider =
    NotifierProvider<PermissionsNotifier, Permissions>(
  PermissionsNotifier.new,
);
