import 'package:flutter/cupertino.dart';

/// A [child] widget wrapped by this will be invisible by default and will
/// only appear if the mouse is hovering above it.
///
/// [padding] makes the hover radius bigger (default 0).
///
/// [enabled] if false, child widget is always invisible.
/// This is mainly for user settings, if they want to manually disable it.
///
/// [maxOpacity] and [minOpacity] are the opacity of the widget on hover and
/// on invisible respectively. The range is 0-1 and by default max=1 min=0.
class HoverWrapper extends StatefulWidget {
  const HoverWrapper({
    super.key,
    required this.child,
    this.padding = 0.0,
    this.enabled = true,
    this.maxOpacity = 1,
    this.minOpacity = 0,
  }) : assert(maxOpacity >= 0 && maxOpacity <= 1),
       assert(minOpacity >= 0 && minOpacity <= 1);

  final Widget child;
  final double padding;
  final bool enabled;
  final double maxOpacity;
  final double minOpacity;

  @override
  State<HoverWrapper> createState() => _HoverWrapperState();
}

class _HoverWrapperState extends State<HoverWrapper> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() {
        _hovered = true;
      }),
      onExit: (_) => setState(() {
        _hovered = false;
      }),
      child: AnimatedOpacity(
        // if not enabled, always 1. otherwise depends on _hovered.
        opacity: (!widget.enabled || _hovered)
            ? widget.maxOpacity
            : widget.minOpacity,
        duration: Duration(milliseconds: 150),
        child: Padding(padding: .all(widget.padding), child: widget.child),
      ),
    );
  }
}
