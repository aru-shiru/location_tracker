import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../location_access_request/location_access_request.dart';
import '../../map_view/map_view.dart';
import '../data_access/permissions.dart';

class RootShell extends ConsumerWidget {
  const RootShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allGranted = ref.watch(
      permissionsProvider.select((p) => p.allGranted),
    );
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: allGranted
          ? const MapScreen(key: ValueKey('home'))
          : const LocationPermissionScreen(key: ValueKey('empty')),
    );
  }
}
