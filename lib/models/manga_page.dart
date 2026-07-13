import 'dart:typed_data';

class MangaPage {
  final int _index;
  final String _filename;
  final Uint8List _imageBytes;

  MangaPage(this._index, this._filename, this._imageBytes);

  int get index => _index;
  String get filename => _filename;
  Uint8List get imageBytes => _imageBytes;
}
