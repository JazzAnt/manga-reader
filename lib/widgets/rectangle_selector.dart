import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/widgets/selection_painter.dart';

class RectangleSelector extends StatefulWidget {
  const RectangleSelector({super.key, required this.onSelectionChanged});

  /// Called whenever the selected rectangle changes. Intended to be used with
  /// a painter to show the selection area.
  ///
  /// Returns [Rect] with the coordinates of the selection rectangle.
  /// Coordinates are relative to this widget's container, not absolute.
  /// Returns null if currently not selecting a rectangle (pointer is up).
  final ValueChanged<Rect?> onSelectionChanged;

  @override
  State<RectangleSelector> createState() => _RectangleSelectorState();
}

class _RectangleSelectorState extends State<RectangleSelector> {
  Offset? startPosition;
  Offset? currentPosition;

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
       setState(() {
         startPosition = event.localPosition;
         currentPosition = event.localPosition;
       });
      },
      onPointerMove: (event) {
        setState(() {
          currentPosition = event.localPosition;
          widget.onSelectionChanged(_selectedRect);
        });
      },
      onPointerUp: (event) {
         setState(() {
           startPosition = null;
           currentPosition = null;
         });
      },
      child: CustomPaint(
        painter: SelectionPainter(selection: _selectedRect),
        child: SizedBox.expand(),
      ),
    );
  }

  Rect? get _selectedRect {
    if (startPosition == null || currentPosition == null) return null;
    return Rect.fromPoints(startPosition!, currentPosition!);
  }
}