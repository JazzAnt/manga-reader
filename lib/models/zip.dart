import 'dart:typed_data';

/// Model to contain data from a .zip file.
/// Usually created by `FileReader.selectZip()`
class Zip {
  final String _filename;
  /// The filename of the .zip file (includes the extension).
  String get filename => _filename;

  final Uint8List _bytes;
  /// The data of the .zip file represented as bytes.
  Uint8List get bytes => _bytes;

  Zip(this._filename, this._bytes);
}