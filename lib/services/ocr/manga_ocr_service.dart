import 'package:manga_reader/services/ocr/ocr_service.dart';

class MangaOCRService implements OCRService {
  // Currently returns dummy text
  @override
  Future<dynamic> recognizeText() async {
    return "ろれむいぷしゅむ";
  }
}