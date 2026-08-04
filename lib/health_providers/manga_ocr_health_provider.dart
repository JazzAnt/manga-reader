import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/health_providers/api_health_notifier.dart';
import 'package:manga_reader/services/platform/platform_service.dart';
import 'package:http/http.dart' as http;

/// While being watched, this provider periodically checks for the local
/// MangaOcr Python server's health and exposes a bool that shows the health.
final mangaOcrHealthProvider = NotifierProvider<MangaOcrHealthNotifier, bool>(
  MangaOcrHealthNotifier.new,
);

class MangaOcrHealthNotifier extends ApiHealthNotifier {
  @override
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
}
