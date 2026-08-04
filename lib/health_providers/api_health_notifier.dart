import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This notifier is used for periodic health checks of the API. The way it
/// works is while a ref.watch() is watching a provider with this notifier,
/// it calls check() every 5 seconds and exposes a bool that corresponds to
/// the result of the health check.
abstract class ApiHealthNotifier extends Notifier<bool> {
  Timer? _timer;
  bool _polling = false;

  @override
  bool build() {
    _startPolling();
    ref.onDispose(() {
      _timer?.cancel();
    });
    return false;
  }

  /// Checks the health of the API. Usually done by the simplest API call of the
  /// given service (such as /health or /version) and see if response is valid.
  /// Example:
  /// ```
  /// try {
  ///   final response = http.get(uri);
  ///   state = response.statusCode >= 200 && response.StatusCode < 300;
  ///
  /// } catch (_) {
  ///   state = false;
  /// }
  /// ```
  Future<void> check();

  // This calls check but uses _polling to make sure multiple checks aren't
  // overlapping with each other.
  Future<void> _periodicCheck() async {
    if (_polling) return;

    _polling = true;
    try {
      await check();
    } finally {
      _polling = false;
    }
  }

  void _startPolling() {
    _periodicCheck();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => check());
  }
}
