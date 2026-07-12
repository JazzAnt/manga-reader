import 'dart:io';
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
    // This opens the file picker dialog for users (limited to zip and cbz)
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["zip", "cbz"]
    );

    // If the user doesn't pick a file (e.g. click cancel), it'll return null
    if(result == null) return null;

    // Get file path then use IO to read the file bytes
    String? path = result.files.single.path;
    if (path == null) return null;
    return File(path).readAsBytes();

    // We get the bytes using path instead of result.files.single.bytes because
    // that one returns null (likely because zip files are too large in size)
  }
}