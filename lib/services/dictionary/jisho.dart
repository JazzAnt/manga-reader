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
      // If somehow there's no Japanese entry just skip it
      final japanese = entry['japanese'] as List? ?? [];
      if (japanese.isEmpty || japanese[0]['reading'] == null) continue;

      // if word doesn't exist (no kanji) default to reading
      final String word = japanese[0]['word'] ?? japanese[0]['reading'];
      final String reading = japanese[0]['reading'];

      // If somehow there's no senses then just skip it
      final senses = entry['senses'] as List? ?? [];
      if (senses.isEmpty) continue;

      final List<DictionaryDefinition> definitions = [];
      for (final sense in entry['senses']) {
        // If somehow there's no definition entry just skip it
        final defList = sense['english_definitions'] as List? ?? [];
        if (defList.isEmpty) continue;

        final List<String> englishDefinitions = [];
        for (final englishDefinition in defList) {
          englishDefinitions.add(englishDefinition);
        }

        final posList = sense['parts_of_speech'] as List? ?? [];
        final String pos = posList.isNotEmpty ? posList[0] : "Unknown POS";

        final infoList = sense['info'] as List? ?? [];
        final String info = infoList.isNotEmpty ? infoList[0] : "";

        definitions.add(DictionaryDefinition(pos, englishDefinitions, info));
      }
      // If somehow there's no definition at all, just skip it
      if (definitions.isEmpty) continue;

      entries.add(DictionaryEntry(word, reading, definitions));
    }
    return entries;
  }
}
