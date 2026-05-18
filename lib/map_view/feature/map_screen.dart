import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data_access/location_samples.dart';
import '../data_access/tracking.dart';
import '../ui/status_sheet.dart';
import 'map_view.dart';

class MapScreen extends ConsumerWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final samples = ref.watch(locationSamplesProvider);
    final tracking = ref.watch(trackingEnabledProvider);
    final current = samples.isEmpty ? null : samples.last;

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
          const MapView(),
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.18,
            maxChildSize: 0.85,
            builder: (context, scrollController) => StatusSheet(
              scrollController: scrollController,
              sample: current,
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
