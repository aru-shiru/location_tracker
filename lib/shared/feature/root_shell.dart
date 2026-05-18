import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../location_access_request/location_access_request.dart';
import '../../map_view/map_view.dart';
import '../data_access/permissions.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final permissions = ref.watch(permissionsProvider);
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: permissions.allGranted
          ? const MapScreen(key: ValueKey('home'))
          : LocationPermissionScreen(
              key: const ValueKey('empty'),
              foregroundGranted: permissions.foreground,
              backgroundGranted: permissions.background,
              notificationsGranted: permissions.notifications,
              onRequestAccess: () =>
                  ref.read(permissionsProvider.notifier).grantNext(),
            ),
    );
  }
}
