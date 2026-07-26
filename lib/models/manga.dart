import './manga_page.dart';

/// Represents a manga book.
/// Main purpose is to carry a list of [MangaPage].
class Manga {
  final String _title;
  /// The title of the manga.
  String get title => _title;

  final List<MangaPage> _pages;
  /// A list of [MangaPage] which represents the pages of the manga.
  List<MangaPage> get pages => _pages;

  /// The page count of the Manga
  int get pageCount => _pages.length;

  Manga(this._title, this._pages);
}