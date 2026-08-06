import 'package:manga_reader/models/dictionary_entry.dart';
import 'package:manga_reader/services/dictionary/jisho.dart';

/// Service class to lookup the dictionary.
class DictionaryService {
  /// Returns a list of entries from the given
  Future<List<DictionaryEntry>> lookup(String keyword) async {
    /*
      this class is used over direct Jisho calls for abstraction purposes.
      Jisho is a temporary dictionary that will one day be replaced with a
      local dictionary. The idea is that when that happens, the lookup()
      function would be the only one be changed, the other code can still
      use lookup() with the exact same input and output.
     */
    return Jisho().call(keyword);
  }
}
