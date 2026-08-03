import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/services/platform/platform_service.dart';
import 'package:http/http.dart' as http;

final mangaOcrHealthProvider = NotifierProvider<MangaOcrHealthNotifier, bool>(
  MangaOcrHealthNotifier.new,
);

class MangaOcrHealthNotifier extends Notifier<bool> {
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
    final Uri url = isOnMobile
        ? Uri.parse("http://10.0.2.2:8000/health")
        : Uri.parse("http://127.0.0.1:8000/health");

    try {
      final response = await http.get(url);
      state = response.statusCode == 200;
    } catch (_) {
      state = false;
    }
  }

  void _startPolling() {
    check();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) => check());
  }
}
