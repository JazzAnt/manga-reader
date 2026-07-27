import 'dart:typed_data';

import 'package:manga_reader/models/ocr_response.dart';

abstract class OCRService {
  Future<OCRResponse> recognizeText(Uint8List imageBytes);
}