import 'dart:convert';

import 'package:http/http.dart' as http;

/// Service class to call Jisho API for dictionary.
///
/// Note: This class is just a temporary class until app are updated to handle
/// local dictionaries, though maybe it can be kept for people who doesn't want
/// to download local libraries.
class Jisho {
  final String baseUrl = "https://jisho.org/api/v1/search/words?keyword=";

  /// Make a call to Jisho's API to get the definition of a Japanese word.
  ///
  /// [keyword] is the word to look up on the dictionary. If given a sentence,
  /// Jisho will look up the definition of the first word of the sentence.
  Future<void> call(String keyword) async {
    final Uri url = Uri.parse(baseUrl + Uri.encodeComponent(keyword));

    final response = await http.get(url);

    final json = jsonDecode(response.body);

    for (final entry in json["data"]) {
      //TODO: make a custom object to load this
      final String reading = entry['japanese'][0]['reading'];
      final String definition = entry['senses'][0]['english_definitions'][0];
    }
  }
}
