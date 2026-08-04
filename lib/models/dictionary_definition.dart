/// Represent a possible interpretation of a dictionary lookup.
/// Because words are vague, they can have multiple interpretations
/// and the reader needs to determine the correct one through context.
class DictionaryDefinition {
  final String _pos;
  final List<String> _definitions;
  final String _info;

  DictionaryDefinition(this._pos, this._definitions, this._info);

  /// The part of speech this definition belong to (noun, verb, etc).
  String get pos => _pos;
  /// A list of definitions for this entry.
  List<String> get definitions => _definitions;
  /// Additional info about this sense, if any.
  String get info => _info;
}