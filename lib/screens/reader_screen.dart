import 'package:flutter/foundation.dart';
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
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    _currentIndex = widget.startingPage;

    // Create a list of MemoryImage from bytes.
    // Mostly so I need to write shorter code (don't need widget.manga.pages)
    _pages = widget.manga.pages.map(
            (page) => MemoryImage(page.imageBytes)
    ).toList();

    // This callback makes sure PageView is created and _controller is
    // attached to PageView before attempting to call .jumpToPage()
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_controller.hasClients) {
        // Prepare PageView to start at the starting page
        _controller.jumpToPage(_currentIndex);
        _precacheImageAround(_currentIndex);
      }
    });

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

  // TODO: Add checks to avoid going out of bounds
  void _goToPageIndex(int targetIndex){
    _controller.animateToPage(
        targetIndex,
        duration: Duration(milliseconds: 333),
        curve: Curves.easeInOut
    );
    setState(() {
      _currentIndex = targetIndex;
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
            PageNavigator(
                // Remember to modify this if targeting other desktops
                isOnDesktop: (defaultTargetPlatform == TargetPlatform.windows),
                goToPageIndex: _goToPageIndex,
                currentIndex: _currentIndex,
                pageCount: _pages.length
            )
          ],
        )
      ),
    );
  }
}

class PageNavigator extends StatelessWidget {
  const PageNavigator({
    super.key,
    required this.isOnDesktop,
    required this.goToPageIndex,
    required this.currentIndex,
    required this.pageCount
  });

  final bool isOnDesktop;
  final void Function(int) goToPageIndex;
  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    if (!isOnDesktop) return const SizedBox.shrink();

    return Padding(
      padding: .all(10),
      child: Row(
        mainAxisAlignment: .center,
        children: <Widget>[
          IconButton(
              onPressed: () => goToPageIndex(currentIndex - 1), // TODO: Disable button if page index would invalid
              icon: Icon(Icons.arrow_left)
          ),
          ElevatedButton(
              onPressed: null, // TODO: Navigate to page dialog
              //            Index starts at 0 so need +1, page count doesn't
              child: Text("${currentIndex + 1} / $pageCount")
          ),
          IconButton(
              onPressed: () => goToPageIndex(currentIndex + 1), // TODO: Disable button if page index would invalid
              icon: Icon(Icons.arrow_right)
          ),
        ],
      ),
    );
  }
}