/// Holds the results of an OcrService. Currently only holds text but I'm
/// making an object class anyways in case future variables are to be added.
class OcrResult {
  final String _text;

  OcrResult(this._text);

  /// Gets the Japanese text that was recognized by the OCR.
  String get text => _text;
}
