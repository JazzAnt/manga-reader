import 'package:flutter/material.dart';
import 'package:manga_reader/models/manga.dart';

/// Screen to display pages of a Manga object. Incomplete.
/// 
/// Current progress: displays first page of a Manga object.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  @override
  Widget build(BuildContext context) {
    //TODO: Handle null values
    final Manga? manga = ModalRoute.of(context)?.settings.arguments as Manga? ?? null;

    return Scaffold(
      appBar: AppBar(title: Text("Reader Screen"),),
      body: Padding(padding: EdgeInsetsGeometry.all(16),
        child: ClipRRect(
          child: Image.memory(
              manga!.pages.first.imageBytes
          ),
        ),
      ),
    );
  }
}
