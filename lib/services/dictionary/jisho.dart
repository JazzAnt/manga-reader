import 'dart:convert';

import 'package:http/http.dart' as http;

class Jisho {
  final String baseUrl = "https://jisho.org/api/v1/search/words?keyword=";
  
  Future<void> call(String keyword) async {
    final Uri url = Uri.parse(baseUrl + Uri.encodeComponent(keyword));

    final response = await http.get(url);

    final json = jsonDecode(response.body);

    for(final entry in json["data"]){
      //TODO: make a custom object to load this
      final String reading = entry['japanese'][0]['reading'];
      final String definition = entry['senses'][0]['english_definitions'][0];
    }
  }
}
