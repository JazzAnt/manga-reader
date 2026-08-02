import 'dart:typed_data';
import 'dart:ui';
import 'package:image/image.dart' as img;
import './image_format.dart';

/// Service class to handle image manipulation.
class ImageService {
  /// Crops the given image on the given Rect.
  ///
  /// [imageBytes] the image to crop as bytes.
  /// [cropRect] the rect to crop the image.
  /// [imageFormat] the format of the output. Default is WebP.
  ///
  /// Throws [Exception] if [imageBytes] fails to be decoded (usually if given
  /// bytes isn't an image data) or if [cropRect] parameters are invalid.
  Uint8List cropImage({
    required Uint8List imageBytes,
    required Rect cropRect,
    ImageFormat imageFormat = .png,
  }) {
    final srcImage = img.decodeImage(imageBytes);

    if (srcImage == null) throw Exception("Fail to decode source imageBytes");

    // Make sure crop params are within the image area.
    // The [-1]s are to make sure no floating point rounding causes error.
    int x = cropRect.left.clamp(0, srcImage.width - 1).toInt();
    int y = cropRect.top.clamp(0, srcImage.height - 1).toInt();
    int width = cropRect.width.clamp(0, srcImage.width - 1).toInt();
    int height = cropRect.width.clamp(0, srcImage.height - 1).toInt();

    if (width == 0 || height == 0) {
      throw Exception("cropRect has invalid height or width");
    }

    final img.Image croppedImage = img.copyCrop(
      srcImage,
      x: x,
      y: y,
      width: width,
      height: height,
    );

    late final List<int> croppedEncoded;

    if (imageFormat == .jpg) {
      croppedEncoded = img.encodeJpg(croppedImage);
    } else if (imageFormat == .webp) {
      croppedEncoded = img.encodeWebP(croppedImage);
    } else {
      // default to PNG if none is chosen
      croppedEncoded = img.encodePng(croppedImage);
    }

    return Uint8List.fromList(croppedEncoded);
  }
}
