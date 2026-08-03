import 'dart:convert';
import 'dart:typed_data';

import 'package:manga_reader/models/ocr_result.dart';
import 'package:manga_reader/services/ocr/ocr_service.dart';
import 'package:http/http.dart' as http;
import 'package:manga_reader/services/platform/platform_service.dart';

class DesktopOcr implements OcrService {
  // Currently returns dummy text
  @override
  Future<OcrResult> recognizeText(Uint8List imageBytes) async {
    late final Uri url;

    // TODO: this is for android emulator, change implementation for build
    if (isOnMobile){
      url = Uri.parse("http://10.0.2.2:8000/ocr");
    } else {
      url = Uri.parse("http://127.0.0.1:8000/ocr");
    }

    var request = http.MultipartRequest(
      "POST",
      url
    );

    request.files.add(
      http.MultipartFile.fromBytes("image", imageBytes, filename: "ocr.png")
    );

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    var json = jsonDecode(response.body);

   if (response.statusCode != 200) {
     // TODO: Custom Exception?
     throw Exception("Status Code ${response.statusCode}");
   }

   return OcrResult(text: json["text"]);
  }
}