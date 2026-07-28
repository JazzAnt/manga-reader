import 'dart:typed_data';

import 'package:manga_reader/models/ocr_result.dart';

abstract class OcrService {
  Future<OcrResult> recognizeText(Uint8List imageBytes);
}