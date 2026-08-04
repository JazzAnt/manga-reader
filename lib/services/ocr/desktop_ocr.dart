import 'dart:convert';
import 'dart:typed_data';

import 'package:manga_reader/models/ocr_result.dart';
import 'package:manga_reader/services/ocr/ocr_service.dart';
import 'package:http/http.dart' as http;
import 'package:manga_reader/services/platform/platform_service.dart';

/// Service class to perform OCR on desktop builds.
class DesktopOcr implements OcrService {
  /// Recognize the Japanese text of the given imageBytes.
  /// Works better if the image has been cropped to include only the text.
  ///
  /// [imageBytes] The bytes of the image file to be OCR-ed.
  ///
  /// Throws [Exception] if API request fails.
  ///
  /// Note: This function has no validation that imageBytes are actually an
  /// image file. If given an invalid bytes, the error would happen on the
  /// server side, returning an error status code.
  @override
  Future<OcrResult> recognizeText(Uint8List imageBytes) async {
    // TODO: this is for android emulator, change implementation for apk build
    // TODO: also android should be using their own OCR but for now use this one
    final Uri url = isOnMobile
      ? Uri.parse("http://10.0.2.2:8000/ocr")
      : Uri.parse("http://127.0.0.1:8000/ocr");

    var request = http.MultipartRequest("POST", url);

    request.files.add(
      http.MultipartFile.fromBytes("image", imageBytes, filename: "ocr.png"),
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);

    if (response.statusCode != 200) {
      // TODO: Custom Exception?
      throw Exception("Status Code ${response.statusCode}");
    }

    return OcrResult(json["text"]);
  }
}
