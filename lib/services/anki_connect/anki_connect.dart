import 'dart:convert';

import 'package:manga_reader/services/platform/platform_service.dart';
import 'package:http/http.dart' as http;

/// Service class to handle making calls to AnkiConnect API.
class AnkiConnect {
  /// Perform an API call to AnkiConnect API. See AnkiConnect's GitHub page
  /// to see which [action] and [params] that are available.
  ///
  /// [action] the action of the API call.
  /// [params] the parameters that certain API calls need.
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
