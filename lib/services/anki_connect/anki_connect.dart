import 'dart:convert';

import '../platform/platform_service.dart';
import 'package:http/http.dart' as http;

class AnkiConnect {
  Future<dynamic> call(
    String action, {
    Map<String, dynamic> params = const {},
  }) async {
    final Uri url = isOnMobile
        ? Uri.parse("http://10.0.2.2:8765/health")
        : Uri.parse("http://127.0.0.1:8765/health");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"action": action, "version": 6, "params": params}),
    );

    final json = jsonDecode(response.body);

    if (json["error"] != null) {
      throw Exception(json["error"]);
    }

    return json["result"];
  }
}
