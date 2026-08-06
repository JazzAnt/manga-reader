import 'package:flutter/material.dart';

/// This painter is used by RectangleSelector to draw the selection area.
///
/// [liveRect] The selection area while it's being selected by the user.
/// [selectionRect] The selection area after selection is finalized.
class SelectionPainter extends CustomPainter {
  const SelectionPainter({required this.liveRect, required this.selectionRect});
  final Rect? liveRect;
  final Rect? selectionRect;

  @override
  void paint(Canvas canvas, Size size) {
    // Color the live selection area
    if (liveRect != null) {
      final Paint shade = Paint()
        ..color = Colors.lightBlueAccent.withValues(alpha: 0.1);
      canvas.drawRect(liveRect!, shade);

      final Paint border = Paint()
        ..color = Colors.lightBlueAccent
        ..style = .stroke
        ..strokeWidth = 1;
      canvas.drawRect(liveRect!, border);
    }

    // Color the defined selection area
    if (selectionRect != null) {
      final Paint shade = Paint()..color = Colors.blue.withValues(alpha: 0.2);
      canvas.drawRect(selectionRect!, shade);

      final Paint border = Paint()
        ..color = Colors.blue
        ..style = .stroke
        ..strokeWidth = 1;
      canvas.drawRect(selectionRect!, border);
    }
  }

  @override
  bool shouldRepaint(covariant SelectionPainter oldDelegate) {
    return oldDelegate.liveRect != liveRect;
  }
}
