import 'dart:typed_data';

class Zip {
  final String _filename;
  final Uint8List _bytes;

  Zip(this._filename, this._bytes);

  String get filename => _filename;
  Uint8List get bytes => _bytes;
}