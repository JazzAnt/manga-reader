import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/models/manga.dart';

/// Screen to display pages of a Manga object.
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
  bool _showIndicator = false;
  Timer? _showIndicatorTimer;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reader Screen")),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Stack(
          children: [
            Align(
              alignment: .center,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (index) {_onPageChange(index);},
                scrollDirection: Axis.horizontal,
                allowImplicitScrolling: true,
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  return InteractiveViewer(
                    child: Image(image: _pages[index],),
                  );
                },
              ),
            ),
            Align(
              alignment: .bottomCenter,
              child: PageNavigator(
                  isOnDesktop: _isOnDesktop,
                  goToPageIndex: _goToPageIndex,
                  currentIndex: _currentIndex,
                  pageCount: _pages.length
              ),
            ),
            Align(
              alignment: .topCenter,
              child: AnimatedOpacity(
                opacity: _showIndicator ? 1 : 0,
                duration: Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                child: PageIndicator(
                    currentIndex: _currentIndex,
                    pageCount: _pages.length
                ),
              ),
            )
          ],
        )
      ),
    );
  }
  // Moves the PageView to a target page index.
  void _goToPageIndex(int targetIndex){
    // If out of bounds, do nothing.
    if (targetIndex < 0 || targetIndex >= _pages.length) return;

    _controller.animateToPage(
        targetIndex,
        duration: Duration(milliseconds: 333),
        curve: Curves.easeInOut
    );
    _onPageChange(targetIndex);
  }

  // Bundles all functions that should happen when page is changed.
  void _onPageChange(int targetIndex){
    _precacheImageAround(targetIndex);
    setState(() {
      _currentIndex = targetIndex;

      // Cancel timer if already exists, used when user is changing pages fast.
      _showIndicatorTimer?.cancel();

      // Show indicator, then turn it off once timer runs out.
      _showIndicator = true;
      _showIndicatorTimer = Timer(Duration(seconds: 1), () {
        setState(() {
          _showIndicator = false;
        });
      });
    });
  }

  // Pre-cache all images before and after the current index, smoother user exp.
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

  // return true only if on native desktop apps. false if web or mobile.
  bool get _isOnDesktop =>
    !kIsWeb
    && switch (defaultTargetPlatform) {
      .windows || .linux || .macOS => true,
      .android || .fuchsia || .iOS => false,
    };
}

/// Widget that shows a page indicator (e.g. (1/10)).
/// [currentIndex] the current index of the page (starts at 0).
/// [pageCount] the total page count.
class PageIndicator extends StatelessWidget {
  // Note: this function is probably unnecessary as it's just a padded Text
  // but I'm keeping it in case I want to stylize the indicator later.
  // Easier to modify when separated over here.
  const PageIndicator({
    super.key,
    required this.currentIndex,
    required this.pageCount
  });
  final int currentIndex;
  final int pageCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: .directional(top: 10),
      child: Text("${currentIndex + 1}/$pageCount"),
    );
  }
}

/// Buttons that handle page switching for desktop where swipe is disabled.
/// [isOnDesktop] if false then this shows no widget.
/// [goToPageIndex] a function to handle page switching. arg is target page.
/// [currentIndex] the current index of the page (starts at 0).
/// [pageCount] the total page count.
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
          // TODO: Better buttons?
          // I was thinking maybe a button on the sides that fade in when
          // mouse is hovering on the side is more intuitive than this.
          // But this is good enough for now.
          IconButton(
              onPressed: () => goToPageIndex(currentIndex - 1), // TODO: Disable button if page index would invalid
              icon: Icon(Icons.arrow_left)
          ),
          ElevatedButton(
              onPressed: null, // TODO: Navigate to page jump dialog which allow user to jump to specific page
              // As the to-do says, the idea is to show a dialog or popup
              // where there's a number input or a slider or something that
              // lets the user quickly jump to a distant page.
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