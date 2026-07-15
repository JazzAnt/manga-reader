import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:manga_reader/models/manga.dart';

/// Screen to display pages of a Manga object. Incomplete.
///
/// Current progress: basic navigation between pages. no error validation.
class ReaderScreen extends StatefulWidget {
  final Manga manga;
  const ReaderScreen({super.key, required this.manga});

  @override
  State<StatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // Page starts as 0 to match index
  int page = 0;

  void next(){
    if (page == widget.manga.pages.length - 1) return;
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

  @override
  Widget build(BuildContext context) {
    final Uint8List image = widget.manga.pages[page].imageBytes;

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
