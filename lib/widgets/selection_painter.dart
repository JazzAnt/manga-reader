import 'package:flutter/cupertino.dart';

class SelectionPainter extends CustomPainter {
  const SelectionPainter({required this.selection});
  final Rect? selection;

  @override
  void paint(Canvas canvas, Size size) {
    print("Repaint Called");
  }

  @override
  bool shouldRepaint(covariant SelectionPainter oldDelegate) {
    return oldDelegate.selection != selection;
  }

}