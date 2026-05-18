import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as fm;
import 'package:latlong2/latlong.dart';

const _defaultCenter = LatLng(-6.20088, 106.84559); // Bundaran HI, Jakarta.

class MapView extends StatefulWidget {
  const MapView({super.key, required this.track, this.current});

  final List<LatLng> track;
  final LatLng? current;

  @override
  State<MapView> createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  final _controller = fm.MapController();

  @override
  void didUpdateWidget(MapView oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.current;
    if (next != null && next != oldWidget.current) {
      _controller.move(next, _controller.camera.zoom);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return fm.FlutterMap(
      mapController: _controller,
      options: fm.MapOptions(
        initialCenter: widget.current ?? _defaultCenter,
        initialZoom: 16,
        minZoom: 3,
        maxZoom: 19,
        interactionOptions: const fm.InteractionOptions(
          flags: fm.InteractiveFlag.all & ~fm.InteractiveFlag.rotate,
        ),
      ),
      children: [
        fm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.location_tracker',
          maxNativeZoom: 19,
        ),
        if (widget.track.length >= 2)
          fm.PolylineLayer(
            polylines: [
              fm.Polyline(
                points: widget.track,
                strokeWidth: 5,
                color: scheme.primary,
              ),
            ],
          ),
        if (widget.current != null)
          fm.MarkerLayer(
            markers: [
              fm.Marker(
                point: widget.current!,
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
