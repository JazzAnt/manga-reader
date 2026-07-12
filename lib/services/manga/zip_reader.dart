import 'dart:typed_data';
import 'package:archive/archive.dart';

/// Class to handle management of zip files
class ZipReader {
  /// Reads a zip file (TODO: currently only prints the data)
  ///
  /// Argument [zipBytes] can be obtained from `FileReader.selectZip()`
  void readZip(Uint8List zipBytes){
    Archive archive = ZipDecoder().decodeBytes(zipBytes);
    for (ArchiveFile file in archive){
      if(file.isFile){
print("(ZIPREADER)" + file.name);
      }
    }
  }
}