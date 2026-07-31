import 'dart:async';

import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/manga.dart';
import 'package:manga_reader/providers/reader_provider.dart';
import 'package:manga_reader/widgets/hover_wrapper.dart';
import 'package:manga_reader/widgets/rectangle_selector.dart';

import '../services/ocr/desktop_ocr.dart';

/// Screen to display pages of a Manga object.
class ReaderScreen extends ConsumerStatefulWidget {
  const ReaderScreen({super.key});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  late PageController _pageController;
  final List<TransformationController> _transformationControllers = [];
  final FocusNode _focusNode = FocusNode();
  bool _startingPageHandled = false;
  bool _showIndicator = false;
  Timer? _showIndicatorTimer;
  bool _selectorActive = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    // TODO: Memorize latest page when user leaves reader while reading manga

    // Triggers when provider is updated
    ref.listenManual(readerProvider, (prev, next) {
      // Trigger only once
      if (_startingPageHandled) return;

      next.whenData((reader) {
        // do nothing if reader null
        if (reader == null) return;

        // Populate tControllers once pageCount is known
        for (int i = 0; i < reader.manga.pageCount; i++) {
          _transformationControllers.add(TransformationController());
        }

        // Precache images
        _precacheImageAround(reader.currentIndex);

        // Waits until PageView exists for pageController jump
        WidgetsBinding.instance.addPostFrameCallback((_) {
          // Waits until controller has clients (PageView)
          if (_pageController.hasClients) {
            _pageController.jumpToPage(reader.currentIndex);
            _startingPageHandled = true;

            //TODO Remove these test functions
            // final page = reader.manga.pages.first;
            // DesktopOcr().recognizeText(page.imageBytes).then((result) {
            //   print("OCR TEST RESULT:");
            //   print(result.text);
            // });
          }
        });
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _focusNode.dispose();
    _showIndicatorTimer?.cancel();
    for (TransformationController controller in _transformationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reader = ref.watch(readerProvider);
    return Focus(
      focusNode: _focusNode,
      autofocus: true,
      onKeyEvent: (node, event) => _onKeyEvent(node, event, reader),
      child: GestureDetector(
        onTap: () {
          _focusNode.requestFocus();
        },
        child: Padding(
          padding: EdgeInsetsGeometry.all(16),
          child: reader.when(
            data: (readerState) => readerState == null
                ? Text("Reader State is Null") //TODO: Custom screen for null
                : LayoutBuilder(
                    builder: (builder, constraints) {
                      return Stack(
                        children: [
                          ReaderWidget(
                            pageController: _pageController,
                            transformationControllers:
                                _transformationControllers,
                            onPageChange: _onPageChange,
                            goToPageIndex: _goToPageIndex,
                            activateSelector: () {
                              setState(() {
                                _selectorActive = true;
                              });
                            },
                            manga: readerState.manga,
                            currentIndex: readerState.currentIndex,
                            showIndicator: _showIndicator,
                            isOnDesktop: _isOnDesktop,
                          ),
                          IgnorePointer(
                            ignoring: !_selectorActive,
                            child: RectangleSelector(
                              isActive: _selectorActive,
                              constraints: constraints,
                              onSelectionFinished: (rect) async {

                                setState(() {
                                  _selectorActive = false;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
            // TODO: Custom Loading Screen?
            loading: () => Center(child: CircularProgressIndicator()),
            // TODO: Custom error screen
            error: (error, stack) => Text(error.toString() + stack.toString()),
          ),
        ),
      ),
    );
  }

  // Handles onKeyEvent of Focus(). Placed here to not bloat build().
  KeyEventResult _onKeyEvent(
    FocusNode node,
    KeyEvent event,
    AsyncValue<ReaderState?> reader,
  ) {
    // Ignore if event isn't keydown
    if (event is! KeyDownEvent) return KeyEventResult.ignored;

    // Ignore if provider is null
    final ReaderState? readerState = reader.value;
    if (readerState == null) return KeyEventResult.ignored;

    // TODO: Setting for users to modify these
    // Go Previous Page
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft &&
        readerState.currentIndex > 0) {
      _goToPageIndex(readerState.currentIndex - 1);
      return KeyEventResult.handled;
    }
    // Go Next Page
    if (event.logicalKey == LogicalKeyboardKey.arrowRight &&
        readerState.currentIndex < readerState.manga.pageCount - 1) {
      _goToPageIndex(readerState.currentIndex + 1);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  // Moves the PageView to a target page index. This also calls _onPageChange()
  // so no need to call that again if navigating using this.
  void _goToPageIndex(int targetIndex) {
    final indexValid = ref
        .read(readerProvider.notifier)
        .isIndexWithinBounds(targetIndex);
    if (!indexValid) return;

    _pageController.animateToPage(
      targetIndex,
      duration: Duration(milliseconds: 333),
      curve: Curves.easeInOut,
    );
    _onPageChange(targetIndex);
  }

  // Bundles all functions that should happen when page is changed.
  void _onPageChange(int targetIndex) {
    ref.read(readerProvider.notifier).setIndex(targetIndex);
    _precacheImageAround(targetIndex);
    setState(() {
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
  void _precacheImageAround(int index, {int radius = 3}) async {
    final reader = ref.read(readerProvider).value;
    if (reader == null) return;

    final pages = reader.manga.pages;
    // For loop from (index - radius) to (index + radius)
    for (int i = index - radius; i <= index + radius; i++) {
      // Skip if [i] is below 0 or above max index
      if (i < 0 || i >= pages.length) continue;
      // Pre-cache image in index [i]
      precacheImage(pages[i].memoryImage, context);
    }
  }

  // Returns a Size(width, height) if the image on the given index.
  // Seems like a complex function for a simple functionality, but doing it
  // this way ensures the function reuses the ImageCache and doesn't have to
  // recreate the image just to know the size.
  Future<Size> _getImageSize(BuildContext context, int index) async {
    final reader = ref.read(readerProvider).value;
    // throw Exception if reader is null because it's unlikely to happen and
    // I don't want the return to be nullable just for this unlikely event
    if (reader == null) throw Exception("getImageSize reader is null!");

    // Reuse the MemoryImage stored in MangaPage
    final ImageProvider provider = reader.manga.pages[index].memoryImage;

    // Completer is used to manually fulfill Future since listener uses callback
    final Completer<Size> completer = Completer<Size>();

    // Retrieve the ImageStream from MemoryImage. As in fetch it from the cache
    // or create the ImageCache if none is found.
    final ImageStream imageStream = provider.resolve(
      createLocalImageConfiguration(context),
    );

    // Listener that handles the ImageStream
    late final ImageStreamListener listener;
    listener = ImageStreamListener(
      (ImageInfo imageInfo, bool _) {
        // If listener has listened, just remove it to prevent memory leak.
        // We do this because we only need to listen to it once.
        imageStream.removeListener(listener);

        // Retrieve size from ImageInfo
        final Size imageSize = Size(
          imageInfo.image.width.toDouble(),
          imageInfo.image.height.toDouble(),
        );
        // This resolves Future<Size>
        completer.complete(imageSize);
      },
      onError: (error, stackTrace) {
        imageStream.removeListener(listener);
        completer.completeError(error, stackTrace);
      },
    );

    // Attach listener to imageStream
    imageStream.addListener(listener);
    // This returns the Future<Size>, which is handled with completer.
    return completer.future;
  }

  // Adjusts a rect to match the scene of the given index.
  // Intended to make a selector rect match an InteractiveViewer's pan or zoom.
  Rect _transformRect(Rect rect, int index) {
    TransformationController controller = _transformationControllers[index];
    Offset topLeft = rect.topLeft;
    Offset bottomRight = rect.bottomRight;
    return Rect.fromPoints(
      controller.toScene(topLeft),
      controller.toScene(bottomRight),
    );
  }

  // Gets the display image rect, which is the rect of the image after being
  // imposed to the Image() using BoxFit.contain
  Rect _getDisplayRect(Size imageSize, Size widgetSize) {
    // This gets the size of the image when imposed into a widgetSize sized
    // widget using BoxFit.contain
    // (if BoxFit type is changed remember to change this)
    final Size displaySize = applyBoxFit(
      .contain,
      imageSize,
      widgetSize,
    ).destination;

    // Get left and top margin from the difference between display and widget
    final left = (widgetSize.width - displaySize.width) / 2;
    final top = (widgetSize.height - displaySize.height) / 2;

    // Return the display rect from the margins and size
    return Rect.fromLTWH(left, top, displaySize.width, displaySize.height);
  }

  // Gets the Rect of the selection area imposed to the actual image pixels.
  // displayRect is the Rect of the image display, use _getDisplayRect for it.
  // adjustedSelection is selectionRect after transformRect and intersected.
  Rect _getCropRect(
      Size imageSize,
      Rect displayRect,
      Rect adjustedSelectionRect
      ){
    // Adjust margins to be relative to displayRect instead of parent
    final left = adjustedSelectionRect.left - displayRect.left;
    final right = adjustedSelectionRect.right - displayRect.left;
    final top = adjustedSelectionRect.top - displayRect.top;
    final bottom = adjustedSelectionRect.bottom - displayRect.top;

    // Convert to percentages relative to displayRect;
    final leftPercent = left / displayRect.width;
    final rightPercent = right / displayRect.width;
    final topPercent = top / displayRect.height;
    final bottomPercent = bottom / displayRect.height;

    // Use percentages with imageSize to get the true pixel margins of the rect.
    final leftPixels = leftPercent * imageSize.width;
    final rightPixels = rightPercent * imageSize.width;
    final topPixels = topPercent * imageSize.height;
    final bottomPixels = bottomPercent * imageSize.height;

    // Create a rect with the pixel size margins
    return Rect.fromLTRB(leftPixels, topPixels, rightPixels, bottomPixels);
  }

  // return true only if on native desktop apps. false if web or mobile.
  bool get _isOnDesktop =>
      !kIsWeb &&
      switch (defaultTargetPlatform) {
        .windows || .linux || .macOS => true,
        .android || .fuchsia || .iOS => false,
      };
}

/// Widget to show the Manga along with controller UI elements.
class ReaderWidget extends StatelessWidget {
  final PageController pageController;
  final List<TransformationController> transformationControllers;
  final void Function(int) onPageChange;
  final void Function(int) goToPageIndex;
  final void Function() activateSelector;

  final Manga manga;
  final int currentIndex;

  final bool showIndicator;
  final bool isOnDesktop;

  const ReaderWidget({
    super.key,
    required this.pageController,
    required this.transformationControllers,
    required this.onPageChange,
    required this.goToPageIndex,
    required this.activateSelector,
    required this.manga,
    required this.currentIndex,
    required this.showIndicator,
    required this.isOnDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Align(
          alignment: .center,
          child: PageView.builder(
            // PageStorageKey prevents page resetting on rebuild (e.g. when
            // desktop reader change from wide to narrow. The $manga.title
            // makes sure keys aren't reused when changing between books.
            key: PageStorageKey("reader_${manga.title}"),
            controller: pageController,
            onPageChanged: (index) {
              onPageChange(index);
            },
            scrollDirection: Axis.horizontal,
            allowImplicitScrolling: true,
            itemCount: manga.pageCount,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                transformationController: transformationControllers[index],
                child: Image(
                  image: manga.pages[index].memoryImage,
                  fit: BoxFit.contain,
                  //TODO: allow user to choose between contain, fitH, fitW
                ),
              );
            },
          ),
        ),
        Align(
          alignment: .bottomCenter,
          // TODO: settings for user to disable it if they want to
          child: HoverWrapper(
            padding: 6,
            child: PageNavigator(
              isOnDesktop: isOnDesktop,
              goToPageIndex: goToPageIndex,
              currentIndex: currentIndex,
              pageCount: manga.pageCount,
            ),
          ),
        ),
        Align(
          alignment: .topCenter,
          child: AnimatedOpacity(
            opacity: showIndicator ? 1 : 0,
            duration: Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            child: PageIndicator(
              currentIndex: currentIndex,
              pageCount: manga.pageCount,
            ),
          ),
        ),
        Align(
          alignment: .topRight,
          child: HoverWrapper(
            child: ElevatedButton(
              onPressed: activateSelector,
              child: Text("OCR"),
            ),
          ),
        ),
      ],
    );
  }
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
    required this.pageCount,
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
    required this.pageCount,
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
            onPressed: currentIndex > 0
                ? () => goToPageIndex(currentIndex - 1)
                : null,
            icon: Icon(Icons.arrow_left),
          ),
          ElevatedButton(
            onPressed:
                null, // TODO: Navigate to page jump dialog which allow user to jump to specific page
            child: Text("${currentIndex + 1} / $pageCount"),
          ),
          IconButton(
            onPressed: currentIndex < pageCount - 1
                ? () => goToPageIndex(currentIndex + 1)
                : null,
            icon: Icon(Icons.arrow_right),
          ),
        ],
      ),
    );
  }
}
