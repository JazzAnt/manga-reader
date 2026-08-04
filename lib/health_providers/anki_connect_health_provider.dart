import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/health_providers/api_health_notifier.dart';
import 'package:manga_reader/services/anki_connect/anki_connect.dart';

/// While being watched, this provider periodically checks for AnkiConnect's
/// health and exposes a bool that shows the health.
final ankiConnectHealthProvider =
    NotifierProvider<AnkiConnectHealthNotifier, bool>(
      AnkiConnectHealthNotifier.new,
    );

class AnkiConnectHealthNotifier extends ApiHealthNotifier {
  @override
  Future<void> check() async {
    try {
      final version = await AnkiConnect().call("version");
      state = version != null;
    } catch (_) {
      state = false;
    }
  }
}
