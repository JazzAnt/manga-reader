import 'package:flutter/material.dart';
import 'package:manga_reader/screens/selector_screen.dart';
import './services/manga/file_reader.dart';
import './services/manga/zip_handler.dart';
import './models/zip.dart';
import './screens/reader_screen.dart';
import 'models/manga.dart';

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
      initialRoute: "/",
      routes: {
        "/": (context) => const SelectorScreen(),
      },
      onGenerateRoute: (settings){
        switch (settings.name){
          case "/reader":
            final manga = settings.arguments as Manga;

            return MaterialPageRoute(
                builder: (_) => ReaderScreen(manga: manga)
            );
        }
        return null;
      },
    );
  }
}
