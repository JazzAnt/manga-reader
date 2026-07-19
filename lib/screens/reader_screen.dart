import 'package:flutter/material.dart';
import 'package:manga_reader/models/manga.dart';

/// Screen to display pages of a Manga object. Incomplete.
///
/// Current progress: basic navigation between pages. no error validation.
class ReaderScreen extends StatefulWidget {
  final Manga manga;
  final int startingPage;
  // Starting page defaults to 0.
  // But can be modified for continue reading.
  // TODO: Memorize latest page when user leaves reader while reading manga
  // NOTE: There is no check is startingPage exceeded the manga page count.
  // This widget assumes that both arguments are valid.
  // TODO: Add a check to the app function that calls ReaderScreen
  const ReaderScreen({super.key, required this.manga, this.startingPage = 0});

  @override
  State<StatefulWidget> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  late PageController _controller;
  late List<MemoryImage> _pages;

  @override
  void initState() {
    super.initState();
    _controller = PageController();

    // Create a list of MemoryImage from bytes.
    // Mostly so I need to write shorter code (don't need widget.manga.pages)
    _pages = widget.manga.pages.map(
            (page) => MemoryImage(page.imageBytes)
    ).toList();

    // Change page to startingPage
    _controller.jumpToPage(widget.startingPage);
    // Preload images around startingPage
    _precacheImageAround(widget.startingPage);
  }

  // This pre-load and cache images before and after the given [index]
  // Thus it would already be loaded when the user swipes to the next or
  // previous page.
  // This should be called on every time page in PageView is changed.
  // [radius] is the range of preload, for example in the default of 3 it would
  // preload the 3 next and 3 previous images.
  // TODO: Settings page where user can customize radius
  void _precacheImageAround(int index, {int radius = 3}){
    // For loop from (index - radius) to (index + radius)
      for (int i = index - radius; i <= index + radius; i++){
        // Skip if [i] is below 0 or above max index
        if (i < 0 || i >= _pages.length) continue;
        // Pre-cache image in index [i]
        precacheImage(_pages[i], context);
      }
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
              controller: _controller,
              onPageChanged: (index) {_precacheImageAround(index);},
              scrollDirection: Axis.horizontal,
              allowImplicitScrolling: true,
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return InteractiveViewer(
                  child: Image(image: _pages[index],),
                );
              },
            ),
          ],
        )
      ),
    );
  }
}
