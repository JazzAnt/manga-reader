import 'dart:typed_data';

import 'package:manga_reader/models/ocr_result.dart';

abstract class OCRService {
  Future<OCRResult> recognizeText(Uint8List imageBytes);
}