import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';

import '../../models/zip.dart';

/// Service class for handling files using File Picker library.
class FileReader {
  /// Asks the user to pick a .zip (or .cbz) file.
  ///
  /// Return a [Zip] object, or null if user file picker is cancelled.
  Future<Zip?> selectZip() async {
    // Opens the file picker dialog for users (limited to zip and cbz)
    FilePickerResult? result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["zip", "cbz"],
    );

    // If the user doesn't pick a file (e.g. click cancel), it'll return null
    if (result == null) return null;

    // This throws an error if file is somehow not single.
    PlatformFile file = result.files.single;

    // Get file path then use IO to read the file bytes.
    // I don't use file.bytes because that returns null for some reason.
    String? path = file.path;
    if (path == null) return null;
    Uint8List bytes = await File(path).readAsBytes();

    return Zip(file.name, bytes);
  }
}
