import './manga_page.dart';

class Manga {
  final String _title;
  final List<MangaPage> _pages;

  Manga(this._title, this._pages);

  String get title => _title;
  List<MangaPage> get pages => _pages;
}