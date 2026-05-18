import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data_access/models/location_sample.dart';

class StatusSheet extends StatelessWidget {
  const StatusSheet({
    super.key,
    required this.scrollController,
    required this.tracking,
    required this.onTrackingChanged,
    this.sample,
  });

  final ScrollController scrollController;
  final LocationSample? sample;
  final bool tracking;
  final ValueChanged<bool> onTrackingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeFmt = DateFormat.Hms();
    final sample = this.sample;

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
          if (sample != null) ...[
            Row(
              children: [
                Expanded(
                  child: Text(
                    '${sample.latLng.latitude.toStringAsFixed(5)}, '
                    '${sample.latLng.longitude.toStringAsFixed(5)}',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _AccuracyBadge(meters: sample.accuracyMeters),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Last update ${timeFmt.format(sample.recordedAt)}',
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
          _DetailRow(label: 'Activity', value: _formatActivity(sample?.activity)),
          _DetailRow(label: 'Speed', value: _formatSpeed(sample?.speedMetersPerSecond)),
          _DetailRow(label: 'Altitude', value: _formatAltitude(sample?.altitudeMeters)),
          _DetailRow(label: 'Heading', value: _formatHeading(sample?.headingDegrees)),
        ],
      ),
    );
  }
}

String _formatActivity(String? activity) {
  if (activity == null) return '—';
  // Plugin emits values like 'still', 'on_foot', 'walking', 'running',
  // 'in_vehicle', 'on_bicycle', 'unknown'. Prettify for display.
  return activity
      .split('_')
      .map((w) => w.isEmpty ? w : w[0].toUpperCase() + w.substring(1))
      .join(' ');
}

String _formatSpeed(double? metersPerSecond) {
  if (metersPerSecond == null) return '—';
  final kmh = metersPerSecond * 3.6;
  return '${kmh.toStringAsFixed(1)} km/h';
}

String _formatAltitude(double? meters) {
  if (meters == null) return '—';
  return '${meters.toStringAsFixed(0)} m';
}

String _formatHeading(double? degrees) {
  if (degrees == null) return '—';
  const directions = ['N', 'NE', 'E', 'SE', 'S', 'SW', 'W', 'NW'];
  final index = (((degrees % 360) + 22.5) / 45).floor() % 8;
  return '${directions[index]} ${degrees.toStringAsFixed(0)}°';
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
