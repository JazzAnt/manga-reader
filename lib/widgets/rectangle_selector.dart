import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RectangleSelector extends StatefulWidget {
  const RectangleSelector({super.key});

  @override
  State<RectangleSelector> createState() => _RectangleSelectorState();
}

class _RectangleSelectorState extends State<RectangleSelector> {
  Offset? startPosition;
  Offset? currentPosition;

  @override
  void initState() {
    super.initState();
    print("Rectangle Selector Active!");
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      behavior: HitTestBehavior.opaque,
      onPointerDown: (event) {
        print("onPointerDown Called");
       setState(() {
         startPosition = event.localPosition;
       });
      },
      onPointerMove: (event) {
        setState(() {
          currentPosition = event.localPosition;
        });
      },
      onPointerUp: (event) {
        print("onPointerUp Called");
         setState(() {
           print("Start: ${startPosition.toString()}");
           print("End: ${currentPosition.toString()}");
           startPosition = null;
         });
      },
      child: SizedBox.expand(),
    );
  }

}