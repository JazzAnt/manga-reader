import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/widgets/selection_painter.dart';

class RectangleSelector extends StatefulWidget {
  const RectangleSelector({
    super.key,
    required this.onSelectionChanged,
    required this.isActive,
    this.onSelectionFinished = RectangleSelector._doNothing
  });

  /// Called whenever the selected rectangle changes.
  ///
  /// Returns [Rect] with the coordinates of the selection rectangle.
  /// Coordinates are relative to this widget's container, not absolute.
  /// Returns null if currently not selecting a rectangle (pointer is up).
  final ValueChanged<Rect?> onSelectionChanged;

  /// Called when the selection is complete (onPointerUp).
  final VoidCallback onSelectionFinished;

  /// If false, the selectors doesn't function.
  final bool isActive;

  /// Do nothing. The default function for void callbacks.
  static void _doNothing(){}

  @override
  State<RectangleSelector> createState() => _RectangleSelectorState();
}

class _RectangleSelectorState extends State<RectangleSelector> {
  Offset? startPosition;
  Offset? currentPosition;
  Rect? selectedRect;

  @override
  Widget build(BuildContext context) {

    return LayoutBuilder(builder: (builder, constraints) {
      return Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: (event) {
          if (!widget.isActive) return;
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
          if (!widget.isActive) return;
          // Clamp to constraint within bounds
          final Offset pos = Offset(
              event.localPosition.dx.clamp(0, constraints.maxWidth),
              event.localPosition.dy.clamp(0, constraints.maxHeight)
          );
          setState(() {
            currentPosition = pos;
            widget.onSelectionChanged(_liveRect);
          });
        },
        onPointerUp: (event) {
          if (!widget.isActive) return;
          setState(() {
            selectedRect = _liveRect;
            startPosition = null;
            currentPosition = null;
            widget.onSelectionFinished();
          });
        },
        child: CustomPaint(
          painter: SelectionPainter(liveRect: _liveRect, selectionRect: selectedRect),
          child: SizedBox.expand(),
        ),
      );
    });
  }

  Rect? get _liveRect {
    if (startPosition == null || currentPosition == null) return null;
    return Rect.fromPoints(startPosition!, currentPosition!);
  }
}