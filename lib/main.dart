import 'dart:typed_data';

import 'package:flutter/material.dart';
import './services/manga/file_reader.dart';
import './services/manga/zip_reader.dart';

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
print("Calling FileReader");
                Uint8List? file = await FileReader().selectZip();
print("File Selected, checking if file is null");
                if (file == null){
print("File is null");
                  return;
                }
print("File is not null, calling ZipReader");
                ZipReader().readZip(file);
              },
              child: const Text("TEST")),
        ),
      ),
    );
  }
}
