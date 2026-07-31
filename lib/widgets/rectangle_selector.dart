import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/widgets/selection_painter.dart';

class RectangleSelector extends StatefulWidget {
  const RectangleSelector({
    super.key,
    required this.isActive,
    required this.constraints,
    this.onSelectionFinished = RectangleSelector._doNothing,
  });

  /// Called when the selection is complete (onPointerUp).
  final ValueChanged<Rect> onSelectionFinished;

  /// If false, the selectors doesn't function.
  final bool isActive;

  /// Used to constrain the selection area.
  /// Ideally retrieved from a parent LayoutBuilder
  final BoxConstraints constraints;

  /// Do nothing. The default function for void callbacks.
  static void _doNothing(Rect _) {}

  @override
  State<RectangleSelector> createState() => _RectangleSelectorState();
}

class _RectangleSelectorState extends State<RectangleSelector> {
  Offset? _startPosition;
  Offset? _currentPosition;
  Rect? _selectedRect;

  @override
  Widget build(BuildContext context) {
    final constraints = widget.constraints;

    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        if (!widget.isActive) return;
        // Clamp to constraint within bounds
        final Offset pos = Offset(
          event.localPosition.dx.clamp(0, constraints.maxWidth),
          event.localPosition.dy.clamp(0, constraints.maxHeight),
        );
        setState(() {
          _startPosition = pos;
          _currentPosition = pos;
        });
      },
      onPointerMove: (event) {
        if (!widget.isActive) return;
        // Clamp to constraint within bounds
        final Offset pos = Offset(
          event.localPosition.dx.clamp(0, constraints.maxWidth),
          event.localPosition.dy.clamp(0, constraints.maxHeight),
        );
        setState(() {
          _currentPosition = pos;
        });
      },
      onPointerUp: (event) {
        if (!widget.isActive) return;
        setState(() {
          _selectedRect = _liveRect;
          _startPosition = null;
          _currentPosition = null;
          if (_selectedRect != null) {
            widget.onSelectionFinished(_selectedRect!);
          }
        });
      },
      child: CustomPaint(
        painter: SelectionPainter(
          liveRect: _liveRect,
          selectionRect: _selectedRect,
        ),
        child: SizedBox.expand(),
      ),
    );
  }

  Rect? get _liveRect {
    if (_startPosition == null || _currentPosition == null) return null;
    return Rect.fromPoints(_startPosition!, _currentPosition!);
  }
}
