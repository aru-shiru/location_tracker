import 'package:flutter/widgets.dart';

class PermissionItem {
  const PermissionItem({
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
