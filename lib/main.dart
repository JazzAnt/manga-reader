import 'dart:typed_data';

import 'package:flutter/material.dart';
import './services/manga/file_reader.dart';
import './services/manga/zip_handler.dart';
import './models/zip.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      home: Scaffold(
        body: Center(
          child: ElevatedButton(
              onPressed: () async {
                Zip? file = await FileReader().selectZip();
                if (file == null){
                  return;
                }
                final manga = ZipHandler().zipToManga(file);
print(manga.title);
print(manga.pages.length);
              },
              child: const Text("TEST")),
        ),
      ),
    );
  }
}
