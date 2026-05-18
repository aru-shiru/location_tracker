import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:intl/intl.dart';
import 'package:latlong2/latlong.dart';

void main() {
  runApp(const LocationTrackerApp());
}

class LocationTrackerApp extends StatelessWidget {
  const LocationTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Location Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const RootShell(),
    );
  }
}

class RootShell extends StatefulWidget {
  const RootShell({super.key});

  @override
  State<RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<RootShell> {
  bool _foreground = false;
  bool _background = false;
  bool _notifications = false;

  bool get _allGranted => _foreground && _background && _notifications;

  // Mockup: advance one permission per tap to mimic the real OS dialog flow
  // (foreground → background → notifications). The map only appears once all
  // three are granted.
  void _requestNext() {
    setState(() {
      if (!_foreground) {
        _foreground = true;
      } else if (!_background) {
        _background = true;
      } else if (!_notifications) {
        _notifications = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 280),
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      transitionBuilder: (child, animation) => FadeTransition(
        opacity: animation,
        child: child,
      ),
      child: _allGranted
          ? const HomeScreen(key: ValueKey('home'))
          : EmptyState(
              key: const ValueKey('empty'),
              foregroundGranted: _foreground,
              backgroundGranted: _background,
              notificationsGranted: _notifications,
              onRequestAccess: _requestNext,
            ),
    );
  }
}

class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.foregroundGranted,
    required this.backgroundGranted,
    required this.notificationsGranted,
    required this.onRequestAccess,
  });

  final bool foregroundGranted;
  final bool backgroundGranted;
  final bool notificationsGranted;
  final VoidCallback onRequestAccess;

  String get _ctaLabel {
    if (!foregroundGranted) return 'Grant location access';
    if (!backgroundGranted) return 'Allow background location';
    if (!notificationsGranted) return 'Enable notifications';
    return 'All set';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final grantedCount = (foregroundGranted ? 1 : 0) +
        (backgroundGranted ? 1 : 0) +
        (notificationsGranted ? 1 : 0);

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
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
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
                  _PermissionItem(
                    icon: Icons.location_on_outlined,
                    title: 'Foreground location',
                    subtitle: 'Read GPS while the app is open.',
                    granted: foregroundGranted,
                  ),
                  _PermissionItem(
                    icon: Icons.layers_outlined,
                    title: 'Background location',
                    subtitle: 'Keep recording when the app is closed.',
                    granted: backgroundGranted,
                  ),
                  _PermissionItem(
                    icon: Icons.notifications_active_outlined,
                    title: 'Notifications',
                    subtitle: 'Show the persistent tracking notification.',
                    granted: notificationsGranted,
                  ),
                ],
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: onRequestAccess,
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.my_location),
                  label: Text(_ctaLabel),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$grantedCount of 3 granted · change anytime in Settings.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _PermissionItem {
  const _PermissionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.granted,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool granted;
}

class _PermissionChecklist extends StatelessWidget {
  const _PermissionChecklist({required this.items});

  final List<_PermissionItem> items;

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
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
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
          // Outer pulse ring.
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.06),
            ),
          ),
          // Mid ring.
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: scheme.primary.withValues(alpha: 0.10),
            ),
          ),
          // Inner solid disc.
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
          // Accent ping.
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Dummy track around Bundaran HI, Jakarta. The last point is "current".
  static const List<LatLng> _track = [
    LatLng(-6.20210, 106.84610),
    LatLng(-6.20170, 106.84595),
    LatLng(-6.20130, 106.84580),
    LatLng(-6.20100, 106.84570),
    LatLng(-6.20088, 106.84559),
  ];

  bool _tracking = true;

  LatLng get _current => _track.last;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Location Tracker'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert),
            tooltip: 'More',
          ),
        ],
      ),
      body: Stack(
        children: [
          _MapView(track: _track, current: _current),
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.18,
            maxChildSize: 0.85,
            builder: (context, scrollController) => _StatusSheet(
              scrollController: scrollController,
              current: _current,
              accuracyMeters: 8,
              updatedAt: DateTime.now(),
              tracking: _tracking,
              onTrackingChanged: (v) => setState(() => _tracking = v),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapView extends StatelessWidget {
  const _MapView({required this.track, required this.current});

  final List<LatLng> track;
  final LatLng current;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return FlutterMap(
      options: MapOptions(
        initialCenter: current,
        initialZoom: 16,
        minZoom: 3,
        maxZoom: 19,
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.location_tracker',
          maxNativeZoom: 19,
        ),
        PolylineLayer(
          polylines: [
            Polyline(
              points: track,
              strokeWidth: 5,
              color: scheme.primary,
            ),
          ],
        ),
        MarkerLayer(
          markers: [
            Marker(
              point: current,
              width: 56,
              height: 56,
              alignment: Alignment.center,
              child: _CurrentMarker(color: scheme.primary),
            ),
          ],
        ),
      ],
    );
  }
}

class _CurrentMarker extends StatelessWidget {
  const _CurrentMarker({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withValues(alpha: 0.18),
          ),
        ),
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusSheet extends StatelessWidget {
  const _StatusSheet({
    required this.scrollController,
    required this.current,
    required this.accuracyMeters,
    required this.updatedAt,
    required this.tracking,
    required this.onTrackingChanged,
  });

  final ScrollController scrollController;
  final LatLng current;
  final double accuracyMeters;
  final DateTime updatedAt;
  final bool tracking;
  final ValueChanged<bool> onTrackingChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final timeFmt = DateFormat.Hms();
    final latLngText =
        '${current.latitude.toStringAsFixed(5)}, ${current.longitude.toStringAsFixed(5)}';
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
          Row(
            children: [
              Expanded(
                child: Text(
                  latLngText,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              _AccuracyBadge(meters: accuracyMeters),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Last update ${timeFmt.format(updatedAt)}',
            style: theme.textTheme.bodyMedium?.copyWith(
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
