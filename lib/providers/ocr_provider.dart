import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/ocr_result.dart';
import 'package:manga_reader/services/ocr/desktop_ocr.dart';

/// Provides data, mainly for OCR Screen
final ocrProvider = AsyncNotifierProvider<OcrNotifier, OcrResult?>(
  OcrNotifier.new
);

/// Holds data for OCR provider
class OcrNotifier extends AsyncNotifier<OcrResult?> {
  @override
  FutureOr<OcrResult?> build() {
    return null;
  }

  /// Makes an OCR request and stores it as a state
  Future<void> requestOcr(Uint8List imgBytes) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => DesktopOcr().recognizeText(imgBytes));
  }

  void clearResult() {
    state = AsyncData(null);
  }
}
