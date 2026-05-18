import 'package:flutter/material.dart';

import 'location_access_request/location_access_request.dart';
import 'map_view/map_view.dart';

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
          ? const MapScreen(key: ValueKey('home'))
          : LocationPermissionScreen(
              key: const ValueKey('empty'),
              foregroundGranted: _foreground,
              backgroundGranted: _background,
              notificationsGranted: _notifications,
              onRequestAccess: _requestNext,
            ),
    );
  }
}
