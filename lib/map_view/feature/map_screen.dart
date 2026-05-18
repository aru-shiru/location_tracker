import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import '../ui/map_view.dart';
import '../ui/status_sheet.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
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
          MapView(track: _track, current: _current),
          DraggableScrollableSheet(
            initialChildSize: 0.32,
            minChildSize: 0.18,
            maxChildSize: 0.85,
            builder: (context, scrollController) => StatusSheet(
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
