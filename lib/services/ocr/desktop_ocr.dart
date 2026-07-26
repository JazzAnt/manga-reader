import 'dart:convert';

import 'package:manga_reader/services/ocr/ocr_service.dart';
import 'package:http/http.dart' as http;

class DesktopOCR implements OCRService {
  // Currently returns dummy text
  @override
  Future<dynamic> recognizeText() async {
    Uri url = Uri.parse("http://127.0.0.1:8000/");
   http.Response response = await http.get(url);

   if (response.statusCode == 200){
     return jsonDecode(response.body)["message"];
   }
  }
}