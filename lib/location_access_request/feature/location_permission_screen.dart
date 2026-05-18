import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/shared.dart';
import '../data_access/models/permission_item.dart';

class LocationPermissionScreen extends ConsumerWidget {
  const LocationPermissionScreen({super.key});

  String _ctaLabel(Permissions p) {
    if (!p.foreground) return 'Grant location access';
    if (!p.background) return 'Allow background location';
    if (!p.notifications) return 'Enable notifications';
    return 'All set';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final permissions = ref.watch(permissionsProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            children: [
              const SizedBox(height: 16),
              const _LocationIllustration(),
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
              _PermissionChecklist(
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
                      ref.read(permissionsProvider.notifier).grantNext(),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.my_location),
                  label: Text(_ctaLabel(permissions)),
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

class _LocationIllustration extends StatelessWidget {
  const _LocationIllustration();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.06),
            ),
          ),
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.10),
            ),
          ),
          Container(
            width: 110,
            height: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  scheme.primary,
                  scheme.primary.withValues(alpha: 0.75),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.35),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Icon(
              Icons.location_on,
              size: 56,
              color: scheme.onPrimary,
            ),
          ),
          Positioned(
            top: 28,
            right: 36,
            child: _Ping(color: scheme.tertiary),
          ),
          Positioned(
            bottom: 38,
            left: 30,
            child: _Ping(color: scheme.secondary),
          ),
        ],
      ),
    );
  }
}

class _Ping extends StatelessWidget {
  const _Ping({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 8,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }
}

class _PermissionChecklist extends StatelessWidget {
  const _PermissionChecklist({required this.items});

  final List<PermissionItem> items;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.granted
                        ? scheme.primary.withValues(alpha: 0.12)
                        : scheme.surfaceContainerHighest,
                  ),
                  child: Icon(
                    item.icon,
                    size: 20,
                    color: item.granted
                        ? scheme.primary
                        : scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: item.granted
                      ? Icon(
                          Icons.check_circle,
                          color: scheme.primary,
                          key: const ValueKey('on'),
                        )
                      : Icon(
                          Icons.radio_button_unchecked,
                          color: scheme.outlineVariant,
                          key: const ValueKey('off'),
                        ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
