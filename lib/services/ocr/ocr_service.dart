import 'dart:typed_data';

import 'package:manga_reader/models/ocr_result.dart';

/// This abstract class is to be inherited by other OCR service classes.
abstract class OcrService {
  Future<OcrResult> recognizeText(Uint8List imageBytes);
}
