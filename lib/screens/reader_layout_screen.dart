import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/health_providers/manga_ocr_health_provider.dart';
import 'package:manga_reader/providers/ocr_provider.dart';
import 'package:manga_reader/providers/reader_provider.dart';
import 'package:manga_reader/screens/ocr_screen.dart';
import 'package:manga_reader/screens/reader_screen.dart';
import 'package:manga_reader/services/platform/platform_service.dart';

/// Widget that holds both ReaderScreen and OcrScreen.
/// Layout depends on platform. If on desktop and wide then shows them
/// side-by-side. If on desktop and narrow or if on mobile, show only
/// ReaderScreen while OcrScreen is stored in an endDrawer.
class ReaderLayoutScreen extends ConsumerWidget {
  const ReaderLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReaderState? state = ref.read(readerProvider).value;
    final title = state == null ? "Reader Screen" : state.manga.title;
    final ocrHealth = ref.watch(mangaOcrHealthProvider);
    final ocrStatus = ref.watch(ocrProvider);

    Widget setupOcrScreen(){
      return ocrStatus.when(
          data: (ocrState) => ocrState == null
          ? Center(child: Text(
            ocrHealth ? "Awaiting OCR" : "OCR Unavailable",
            style: const TextStyle(fontWeight: .bold, fontSize: 30),
          ))
          : OcrScreen(),
          error: (error, stacktrace) => Center(child:
            Text(error.toString(), style: TextStyle(
                fontWeight: .bold,
                fontSize: 30,
                color: Colors.red
            ))),
          loading: () => Center(child: CircularProgressIndicator())
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Considered widescreen if width > 900px
        final isWideDesktop = isOnDesktop && constraints.maxWidth > 900;

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          endDrawer: isWideDesktop ? null : setupOcrScreen(),
          body: isWideDesktop
              ? Row(
                  children: [
                    Expanded(flex: 2, child: ReaderScreen()),
                    Expanded(flex: 3, child: setupOcrScreen()),
                  ],
                )
              : ReaderScreen(),
        );
      },
    );
  }
}
