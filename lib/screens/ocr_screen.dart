import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is a placeholder to be placed where the OCR screen will be eventually
class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  String _selection = "";
  Timer? _selectionDelay;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionArea(
          child: Text(
            "私はばかです。でもあなたよりもっとばかすぎる。お前はせかいいちばかにんげん。ばかばかばか",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onSelectionChanged: (selection) {
            _selectionDelay?.cancel();

            final text = selection?.plainText;
            if (text == null || text.isEmpty) {
              setState(() {
                _selection = "";
              });
              return;
            }

            // Selection finalized if selection has stopped for more than 350ms
            _selectionDelay = Timer(const Duration(milliseconds: 350), () {
              setState(() {
                _selection = text;
              });
            });
          },
        ),
        Expanded(child: Text(_selection)),
      ],
    );
  }
}
