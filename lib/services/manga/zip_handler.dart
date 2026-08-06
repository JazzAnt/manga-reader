import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:mime/mime.dart';

import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/models/manga_page.dart';
import 'package:manga_reader/models/zip.dart';

/// Service class to handle zip files. Most functions here require a
/// [Zip] object that can be obtained from `FileReader.selectZip()`.
class ZipHandler {
  /// Reads a [Zip] object and converts it to a [Manga] object.
  /// The [Manga] object contains all image files in the [Zip] object,
  /// any non-image file is ignored.
  ///
  /// Returns a [Manga] object.
  Manga zipToManga(Zip zipFile) {
    Archive archive = ZipDecoder().decodeBytes(zipFile.bytes);

    final List<MangaPage> pages = <MangaPage>[];
    int pageIndex = 0;

    for (ArchiveFile file in archive) {
      // If file isn't a file (is a directory), skip.
      if (!file.isFile) continue;

      // If file is empty, skip.
      final String name = file.name;
      final Uint8List? bytes = file.readBytes();
      if (bytes == null) continue;

      // Look up file's MIME type. If file is not an image, skip.
      final String? mime = lookupMimeType(name, headerBytes: bytes);
      if (mime == null || !mime.startsWith('image/')) continue;

      final MangaPage page = MangaPage(pageIndex, name, bytes);
      pages.add(page);

      // Index incremented here so that it increments only if a page is added.
      pageIndex++;
    }

    return Manga(zipFile.filename, pages);
  }

  /// Reads a zip file and prints the contents.
  /// Currently mostly for testing.
  void readZip(Zip zipFile) {
    Archive archive = ZipDecoder().decodeBytes(zipFile.bytes);
    for (ArchiveFile file in archive) {
      if (file.isFile) {
        print("(ZIPREADER)${file.name}");
      }
    }
  }
}
