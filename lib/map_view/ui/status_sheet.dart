import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

class StatusSheet extends StatelessWidget {
  const StatusSheet({
    super.key,
    required this.scrollController,
    this.current,
    this.accuracyMeters,
    this.updatedAt,
    required this.tracking,
    required this.onTrackingChanged,
  });

  final ScrollController scrollController;
  final LatLng? current;
  final double? accuracyMeters;
  final DateTime? updatedAt;
  final bool tracking;
  final ValueChanged<bool> onTrackingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeFmt = DateFormat.Hms();
    return Material(
      elevation: 8,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      color: scheme.surface,
      child: ListView(
        controller: scrollController,
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: scheme.outlineVariant,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          if (current != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${current!.latitude.toStringAsFixed(5)}, '
                    '${current!.longitude.toStringAsFixed(5)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                if (accuracyMeters != null) ...[
                  const SizedBox(width: 12),
                  _AccuracyBadge(meters: accuracyMeters!),
                ],
              ],
            ),
            const SizedBox(height: 4),
            if (updatedAt != null)
              Text(
                'Last update ${timeFmt.format(updatedAt!)}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
          ] else
            Text(
              'Waiting for first location update…',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: scheme.onSurfaceVariant,
              ),
            ),
          const SizedBox(height: 20),
          Card(
            margin: EdgeInsets.zero,
            child: SwitchListTile.adaptive(
              value: tracking,
              onChanged: onTrackingChanged,
              title: const Text('Background tracking'),
              subtitle: Text(
                tracking
                    ? 'Updates continue when the app is closed.'
                    : 'Tracking is paused.',
              ),
              secondary: Icon(
                tracking ? Icons.my_location : Icons.location_disabled,
                color: tracking ? scheme.primary : scheme.onSurfaceVariant,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Details', style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          const _DetailRow(label: 'Activity', value: 'moving'),
          const _DetailRow(label: 'Speed', value: '4.2 km/h'),
          const _DetailRow(label: 'Altitude', value: '31 m'),
          const _DetailRow(label: 'Heading', value: 'N 24°'),
        ],
      ),
    );
  }
}

class _AccuracyBadge extends StatelessWidget {
  const _AccuracyBadge({required this.meters});

  final double meters;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '±${meters.toStringAsFixed(0)} m',
        style: TextStyle(
          color: scheme.onPrimaryContainer,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
