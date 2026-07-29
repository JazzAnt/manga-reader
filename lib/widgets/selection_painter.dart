import 'package:flutter/material.dart';

class SelectionPainter extends CustomPainter {
  const SelectionPainter({required this.selection});
  final Rect? selection;

  @override
  void paint(Canvas canvas, Size size) {
    if (selection == null) return;

    // Color the selection area translucent blue
    final Paint shade = Paint()
    ..color = Colors.blue.withValues(alpha: 0.25);
    canvas.drawRect(selection!, shade);

    // Color the borders opaque blue
    final Paint border = Paint()
    ..color = Colors.blue
    ..style = .stroke
    ..strokeWidth = 1;
    canvas.drawRect(selection!, border);
  }

  @override
  bool shouldRepaint(covariant SelectionPainter oldDelegate) {
    return oldDelegate.selection != selection;
  }

}