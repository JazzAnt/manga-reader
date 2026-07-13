import 'dart:typed_data';

class MangaPage {
  final int _index;
  final String _filename;
  final Uint8List _imageBytes;

  MangaPage({
    required int index,
    required String filename,
    required Uint8List imageBytes,
  }) : _index = index,
       _filename = filename,
       _imageBytes = imageBytes;

  int get index => _index;
  String get filename => _filename;
  Uint8List get imageBytes => _imageBytes;
}
