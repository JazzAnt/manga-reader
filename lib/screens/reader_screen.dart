import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:manga_reader/models/manga.dart';

/// Screen to display pages of a Manga object. Incomplete.
///
/// Current progress: basic navigation between pages. no error validation.
class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // Page starts as 0 to match index
  int page = 0;
  
  @override
  Widget build(BuildContext context) {
    //TODO: Handle null value manga
    Manga? manga = ModalRoute.of(context)?.settings.arguments as Manga? ?? null;
    Uint8List image = manga!.pages[page].imageBytes;

    void next(){
      if (page == manga.pages.length - 1) return;
      setState(() {
        page = page + 1;
      });
    }

    void previous(){
      if (page == 0) return;
      setState(() {
        page = page - 1;
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text("Reader Screen"),),
      body: Padding(padding: EdgeInsetsGeometry.all(16),
        child: Column(children: [
          SizedBox(
            height: 600,
            child: Image.memory(
                image
            ),
          ),
          Row(
            children: [
              ElevatedButton(onPressed: previous, child: Text("Previous")),
              ElevatedButton(onPressed: next, child: Text("Next"))
            ],
          )
        ],)
      ),
    );
  }
}
