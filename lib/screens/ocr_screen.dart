import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is a placeholder to be placed where the OCR screen will be eventually
class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});


  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OcrScreenState();

}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.blue,
      child: Center(
        child: Text("I AM A PLACEHOLDER", style: TextStyle(color: Colors.red)),
      ),
    );
  }

}
