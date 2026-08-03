import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/providers/reader_provider.dart';
import 'package:manga_reader/screens/reader_screen.dart';
import 'package:manga_reader/services/platform/platform_service.dart';

class ReaderLayoutScreen extends ConsumerWidget {
  const ReaderLayoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ReaderState? state = ref.read(readerProvider).value;
    final title = state == null ? "Reader Screen" : state.manga.title;

    return LayoutBuilder(
      builder: (context, constraints) {
        // Considered widescreen if width > 900px
        final isWideDesktop = isOnDesktop && constraints.maxWidth > 900;

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          endDrawer: isWideDesktop ? null : OCRScreen(),
          body: isWideDesktop
              ? Row(
                  children: [
                    Expanded(flex: 2, child: ReaderScreen()),
                    Expanded(flex: 3, child: OCRScreen()),
                  ],
                )
              : ReaderScreen(),
        );
      },
    );
  }
}

/// This is a placeholder to be placed where the OCR screen will be eventually
class OCRScreen extends ConsumerWidget {
  const OCRScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ColoredBox(
      color: Colors.blue,
      child: Center(
        child: Text("I AM A PLACEHOLDER", style: TextStyle(color: Colors.red)),
      ),
    );
  }
}
