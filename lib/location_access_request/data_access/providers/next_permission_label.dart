import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/shared.dart';

/// User-facing label for the next permission the app needs to request.
///
/// Watches [permissionsProvider] and cascades through the fixed sequence
/// foreground → background → notifications, emitting the prompt copy
/// for whichever permission is next missing. Once every permission in
/// [Permissions] is granted, emits `'All set'`.
///
/// Drives the CTA button label on `LocationPermissionScreen`. Lives here
/// (instead of inside the screen) so the screen file stays free of the
/// branching "which permission comes next" business logic.
final nextPermissionLabelProvider = Provider<String>((ref) {
  final p = ref.watch(permissionsProvider);
  if (!p.foreground) return 'Grant location access';
  if (!p.background) return 'Allow background location';
  if (!p.notifications) return 'Enable notifications';
  return 'All set';
});
