import 'dart:convert';

import 'package:manga_reader/models/ocr_response.dart';
import 'package:manga_reader/services/ocr/ocr_service.dart';
import 'package:http/http.dart' as http;

class DesktopOCR implements OCRService {
  // Currently returns dummy text
  @override
  Future<OCRResponse> recognizeText() async {
    Uri url = Uri.parse("http://127.0.0.1:8000/");
    final response = await http.get(url);
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return OCRResponse(
        data: {"response": jsonDecode(response.body)["message"]},
      );
    }

    return OCRResponse(error: {"code": response.statusCode});
  }
}
