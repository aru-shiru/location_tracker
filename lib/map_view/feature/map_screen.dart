import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_access/track_points.dart';
import '../data_access/tracking.dart';
import '../ui/map_view.dart';
import '../ui/status_sheet.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final track = ref.watch(trackPointsProvider);
    final tracking = ref.watch(trackingEnabledProvider);
    final current = track.last;

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
          MapView(track: track, current: current),
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.18,
            maxChildSize: 0.85,
            builder: (context, scrollController) => StatusSheet(
              scrollController: scrollController,
              current: current,
              accuracyMeters: 8,
              updatedAt: DateTime.now(),
              tracking: tracking,
              onTrackingChanged: (v) =>
                  ref.read(trackingEnabledProvider.notifier).setEnabled(v),
            ),
          ),
        ],
      ),
    );
  }
}
