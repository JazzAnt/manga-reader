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

    return LayoutBuilder(builder: (builder, constraints) {
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          // Clamp to constraint within bounds
          final Offset pos = Offset(
            event.localPosition.dx.clamp(0, constraints.maxWidth),
            event.localPosition.dy.clamp(0, constraints.maxHeight)
          );
          setState(() {
            startPosition = pos;
            currentPosition = pos;
          });
        },
        onPointerMove: (event) {
          // Clamp to constraint within bounds
          final Offset pos = Offset(
              event.localPosition.dx.clamp(0, constraints.maxWidth),
              event.localPosition.dy.clamp(0, constraints.maxHeight)
          );
          setState(() {
            currentPosition = pos;
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
    });
  }

  Rect? get _selectedRect {
    if (startPosition == null || currentPosition == null) return null;
    return Rect.fromPoints(startPosition!, currentPosition!);
  }
}