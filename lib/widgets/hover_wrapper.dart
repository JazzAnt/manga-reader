import 'package:flutter/cupertino.dart';

/// A [child] widget wrapped by this will be invisible by default and will
/// only appear if the mouse is hovering above it.
///
/// [padding] makes the hover radius bigger (default 0).
///
/// [enabled] if false, child widget is always invisible.
/// This is mainly for user settings, if they want to manually disable it.
class HoverWrapper extends StatefulWidget {
  const HoverWrapper({
    super.key,
    required this.child,
    this.padding = 0.0,
    this.enabled = true,
  });

  final Widget child;
  final double padding;
  final bool enabled;

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
        opacity: (!widget.enabled || _hovered) ? 1 : 0,
        duration: Duration(milliseconds: 150),
        child: Padding(padding: .all(widget.padding), child: widget.child),
      ),
    );
  }
}
