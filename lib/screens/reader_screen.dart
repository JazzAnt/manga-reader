import 'dart:ffi';
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

  void next() {
    if (page == widget.manga.pages.length - 1) return;
    setState(() {
      page = page + 1;
    });
  }

  void previous() {
    if (page == 0) return;
    setState(() {
      page = page - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reader Screen")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Stack(
          alignment: .bottomCenter,
          children: <Widget>[
            PageView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.manga.pages.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Image.memory(widget.manga.pages[index].imageBytes),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}
