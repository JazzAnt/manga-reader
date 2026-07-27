import 'dart:convert';
import 'dart:typed_data';

import 'package:manga_reader/models/ocr_response.dart';
import 'package:manga_reader/services/ocr/ocr_service.dart';
import 'package:http/http.dart' as http;

class DesktopOCR implements OCRService {
  // Currently returns dummy text
  @override
  Future<OCRResponse> recognizeText(Uint8List imageBytes) async {
    Uri url = Uri.parse("http://127.0.0.1:8000/upload");

    var request = http.MultipartRequest(
      "POST",
      url
    );

    request.files.add(
      http.MultipartFile.fromBytes("image", imageBytes, filename: "test.png")
    );

    var streamedResponse = await request.send();

    var response = await http.Response.fromStream(streamedResponse);

   if (response.statusCode >= 200 && response.statusCode < 300) {
     return OCRResponse(data: {"response" : jsonDecode(response.body)["size"]});
   }

   return OCRResponse(error: {"code": response.statusCode});
  }
}