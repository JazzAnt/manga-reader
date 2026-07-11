import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

/// Service class for handling files using File Picker library
class FileReader {
  /// Asks the user to pick a .zip (or .cbz) file
  ///
  /// Returns [Uint8List] the file contents as bytes.
  /// The return value is intended to be consumed by `ZipReader.readZip()`
  ///
  /// Returns `null` if no file is selected by the user.
  Future<Uint8List?> selectZip() async {
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["zip", "cbz"]
    );

    if(result == null) return null;

    return result.files.single.bytes;
  }
}