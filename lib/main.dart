import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/screens/reader_layout_screen.dart';
import 'package:manga_reader/screens/selector_screen.dart';
import 'package:manga_reader/services/ocr/ocr_service.dart';

import 'services/ocr/desktop_ocr.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO: Different cache size for Desktop and Android
  // TODO: Allow user to change this in settings
  PaintingBinding.instance.imageCache.maximumSizeBytes =
      300 << 20; // 300 MB Image Cache
  runApp(
    const ProviderScope(
      child: MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: Testing OCR service here, remember to remove when production
    DesktopOCR().recognizeText().then((result){
      print("OCR TEST RESULT:");
      print(result);
    });

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      initialRoute: "/",
      routes: {
        "/": (context) => const SelectorScreen(),
        "/reader": (context) => const ReaderLayoutScreen()
      },
    );
  }
}
