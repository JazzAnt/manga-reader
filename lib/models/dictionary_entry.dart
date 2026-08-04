import 'package:manga_reader/models/dictionary_definition.dart';

/// Represents the result of looking up a Japanese word in a dictionary.
class DictionaryEntry {
  final String _word;
  final String _reading;
  final List<DictionaryDefinition> _definitions;

  DictionaryEntry(this._word, this._reading, this._definitions);

  /// The Japanese word (in kanji if possible).
  String get word => _word;
  /// The kana reading of the word.
  String get reading => _reading;
  /// The list of definitions for this word.
  List<DictionaryDefinition> get definitions => _definitions;
}