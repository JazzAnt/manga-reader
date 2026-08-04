import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:manga_reader/models/dictionary_definition.dart';
import 'package:manga_reader/models/dictionary_entry.dart';

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
  Future<List<DictionaryEntry>> call(String keyword) async {
    final Uri url = Uri.parse(baseUrl + Uri.encodeComponent(keyword));

    final response = await http.get(url);
    if (response.statusCode != 200) throw Exception("Jisho call failed");

    final json = jsonDecode(response.body);
    if (json["data"] == null) throw Exception("Jisho returns no data");

    final List<DictionaryEntry> entries = [];

    for (final entry in json["data"]) {
      // Get word and reading
      final japanese = entry['japanese'][0];
      // if word doesn't exist (no kanji) default to reading
      final String word = japanese['word'] ?? japanese['reading'];
      final String reading = japanese['reading'];

      // Get definitions
      final List<DictionaryDefinition> definitions = [];
      for (final sense in entry['senses']) {
        final String pos = sense['parts_of_speech'][0];
        final String info = sense['infp'][0] ?? "";
        final List<String> englishDefinitions = [];
        for (final englishDefinition in sense['english_definitions']) {
          englishDefinitions.add(englishDefinition);
        }

        definitions.add(DictionaryDefinition(pos, englishDefinitions, info));
      }
      entries.add(DictionaryEntry(word, reading, definitions));
    }
    return entries;
  }
}
