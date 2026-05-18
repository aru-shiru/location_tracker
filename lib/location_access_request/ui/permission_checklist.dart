import 'package:flutter/material.dart';

import '../data_access/models/permission_item.dart';

class PermissionChecklist extends StatelessWidget {
  const PermissionChecklist({super.key, required this.items});

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
