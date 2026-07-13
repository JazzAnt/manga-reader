import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:mime/mime.dart';

import '../../models/manga.dart';
import '../../models/manga_page.dart';

/// Service class to handle zip files. Most functions here require the bytes
/// of the zip file, which can be obtained from `FileReader.selectZip()`
class ZipHandler {
  /// Reads a zip file and converts it to a [Manga] object.
  /// This function reads and stores all image files found in the zip file.
  /// Any non-image file is ignored.
  Manga zipToManga(Uint8List zipBytes){
    Archive archive = ZipDecoder().decodeBytes(zipBytes);

    final List<MangaPage> pages = <MangaPage>[];
    int pageIndex = 0;

    for (ArchiveFile file in archive){
      // If file isn't a file (is a directory), skip.
      if (!file.isFile) continue;

      final String name = file.name;
      final Uint8List? bytes = file.readBytes();
      if (bytes == null) continue;

      // Look up file's MIME type. If file is not an image, skip.
      final String? mime = lookupMimeType(name, headerBytes: bytes);
      if(mime == null || !mime.startsWith('image/')) continue;

      final page = MangaPage(pageIndex, name, bytes);
      pages.add(page);

      // Index incremented here so that it increments only if a page is added.
      pageIndex++;
    }

    // TODO: get a way to implement filename
    return Manga("PLACEHOLDER", pages);
  }

  /// Reads a zip file and prints the contents.
  /// Currently mostly for testing.
  void readZip(Uint8List zipBytes){
    Archive archive = ZipDecoder().decodeBytes(zipBytes);
    for (ArchiveFile file in archive){
      if(file.isFile){
print("(ZIPREADER)" + file.name);
      }
    }
  }
}