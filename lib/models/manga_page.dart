import 'dart:typed_data';

/// Represents an image file of a single page of a manga.
class MangaPage {
  final int _index;
  /// The index of the page. This would normally represent which page it is
  /// in a `Manga`'s list of pages.
  ///
  /// NOTE: Starts at index 0
  int get index => _index;

  final String _filename;
  /// The filename of the image file this represents (extensions included).
  String get filename => _filename;

  final Uint8List _imageBytes;
  /// The image data represented as bytes.
  Uint8List get imageBytes => _imageBytes;

  MangaPage(this._index, this._filename, this._imageBytes);
}
