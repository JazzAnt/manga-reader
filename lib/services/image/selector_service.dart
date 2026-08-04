import 'package:flutter/cupertino.dart';

class SelectorService {
  /// Turns selection rect to crop rect, which corresponds to the actual image.
  ///
  /// [selectionRect] is the Rect received from SelectorScreen
  /// [tfController] is the TransformationController of the InteractiveViewer
  /// holding the Image.
  /// [imageSize] is the size of the image.
  /// [widgetSize] is the size of the image container, get from LayoutBuilder.
  /// [boxFit] the BoxFit of the Image container. Default is BoxFit.contain.
  Rect selectionRectToCropRect({
    required Rect selectionRect,
    required TransformationController tfController,
    required Size imageSize,
    required Size widgetSize,
    BoxFit boxFit = .contain,
  }) {
    // This adjusts the selection Rect to match any pan/zoom of the controller
    Rect transformedRect = _transformRect(selectionRect, tfController);

    // This creates the Rect of the displayed image size (which matches
    // the actual image instead of the parent which might have white space)
    Rect displayRect = _getDisplayRect(imageSize, widgetSize, boxFit);

    // This intersects both Rect above to ensure the selection Rect doesn't
    // go beyond the display Rect
    Rect constrainedRect = transformedRect.intersect(displayRect);

    if (constrainedRect.isEmpty) throw Exception("Selection not on image");

    // This gets the actual crop Rect, scaling the previous Rect (which is
    // based on the Widget) to instead correspond with the actual image size.
    Rect cropRect = _getCropRect(imageSize, displayRect, constrainedRect);
    return cropRect;
  }

  /// Adjusts a rect to match the scene of the given index.
  /// Intended to make a selector rect match an InteractiveViewer's pan or zoom.
  Rect _transformRect(Rect rect, TransformationController controller) {
    Offset topLeft = rect.topLeft;
    Offset bottomRight = rect.bottomRight;
    return Rect.fromPoints(
      controller.toScene(topLeft),
      controller.toScene(bottomRight),
    );
  }

  /// Gets the display image rect, which is the rect of the image after being
  /// imposed to the Image() using BoxFit.contain
  Rect _getDisplayRect(Size imageSize, Size widgetSize, BoxFit boxFit) {
    // This gets the size of the image when imposed into a widgetSize sized
    // widget using BoxFit
    final Size displaySize = applyBoxFit(
      boxFit,
      imageSize,
      widgetSize,
    ).destination;

    // Get left and top margin from the difference between display and widget
    final left = (widgetSize.width - displaySize.width) / 2;
    final top = (widgetSize.height - displaySize.height) / 2;

    // Return the display rect from the margins and size
    return Rect.fromLTWH(left, top, displaySize.width, displaySize.height);
  }

  /// Gets the Rect of the selection area imposed to the actual image pixels.
  /// displayRect is the Rect of the image display, use _getDisplayRect for it.
  /// adjustedSelection is selectionRect after transformRect and intersected.
  Rect _getCropRect(
    Size imageSize,
    Rect displayRect,
    Rect adjustedSelectionRect,
  ) {
    // Adjust margins to be relative to displayRect instead of parent
    final left = adjustedSelectionRect.left - displayRect.left;
    final right = adjustedSelectionRect.right - displayRect.left;
    final top = adjustedSelectionRect.top - displayRect.top;
    final bottom = adjustedSelectionRect.bottom - displayRect.top;

    // Convert to percentages relative to displayRect;
    final leftPercent = left / displayRect.width;
    final rightPercent = right / displayRect.width;
    final topPercent = top / displayRect.height;
    final bottomPercent = bottom / displayRect.height;

    // Use percentages with imageSize to get the true pixel margins of the rect.
    final leftPixels = leftPercent * imageSize.width;
    final rightPixels = rightPercent * imageSize.width;
    final topPixels = topPercent * imageSize.height;
    final bottomPixels = bottomPercent * imageSize.height;

    // Create a rect with the pixel size margins
    return Rect.fromLTRB(leftPixels, topPixels, rightPixels, bottomPixels);
  }
}
