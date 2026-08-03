import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/services/anki_connect/anki_connect.dart';

final ankiConnectHealthProvider = NotifierProvider<AnkiConnectHealthNotifier, bool>(
  AnkiConnectHealthNotifier.new
);

class AnkiConnectHealthNotifier extends Notifier<bool> {
  Timer? _timer;

  @override
  bool build() {
    _startPolling();
    ref.onDispose(() {
      _timer?.cancel();
    });
    return false;
  }

  Future<void> check() async {
    try {
      final version = await AnkiConnect().call("version");
      state = version != null;
    } catch (_) {
      state = false;
    }
  }

  void _startPolling() {
    check();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) => check());
  }
}
