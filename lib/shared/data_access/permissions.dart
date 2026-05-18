import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  Permissions build() => const Permissions();

  // Mockup: advance one permission per call to mimic the OS dialog flow
  // (foreground → background → notifications). Replace with real platform
  // calls when wiring flutter_background_geolocation.
  void grantNext() {
    final s = state;
    if (!s.foreground) {
      state = s.copyWith(foreground: true);
    } else if (!s.background) {
      state = s.copyWith(background: true);
    } else if (!s.notifications) {
      state = s.copyWith(notifications: true);
    }
  }
}

final permissionsProvider =
    NotifierProvider<PermissionsNotifier, Permissions>(
  PermissionsNotifier.new,
);
