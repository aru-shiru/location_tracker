import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrackingNotifier extends Notifier<bool> {
  @override
  bool build() => true;

  void setEnabled(bool enabled) => state = enabled;
}

final trackingEnabledProvider =
    NotifierProvider<TrackingNotifier, bool>(TrackingNotifier.new);
