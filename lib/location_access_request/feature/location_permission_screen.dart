import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shared.dart';
import '../data_access/models/permission_item.dart';
import '../data_access/providers/next_permission_label.dart';
import '../ui/location_illustration.dart';
import '../ui/permission_checklist.dart';

class LocationPermissionScreen extends ConsumerWidget {
  const LocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final permissions = ref.watch(permissionsProvider);
    final ctaLabel = ref.watch(nextPermissionLabelProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const LocationIllustration(),
              const SizedBox(height: 32),
              Text(
                'Track your location',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 12),
              Text(
                'Allow location access so we can record where you’ve been — '
                'even while the app is in the background or closed.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 24),
              PermissionChecklist(
                items: [
                  PermissionItem(
                    icon: Icons.location_on_outlined,
                    title: 'Foreground location',
                    subtitle: 'Read GPS while the app is open.',
                    granted: permissions.foreground,
                  ),
                  PermissionItem(
                    icon: Icons.layers_outlined,
                    title: 'Background location',
                    subtitle: 'Keep recording when the app is closed.',
                    granted: permissions.background,
                  ),
                  PermissionItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications',
                    subtitle: 'Show the persistent tracking notification.',
                    granted: permissions.notifications,
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () =>
                      ref.read(permissionsProvider.notifier).requestNext(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.my_location),
                  label: Text(ctaLabel),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '${permissions.grantedCount} of 3 granted · change anytime in Settings.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
