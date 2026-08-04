import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/providers/ocr_provider.dart';
import 'package:manga_reader/providers/reader_provider.dart';

import 'package:manga_reader/models/zip.dart';
import 'package:manga_reader/services/manga/file_reader.dart';

/// Has a button that opens a file picker and redirects to reader screen.
/// Mostly placeholder screen for testing, will either be updated or
/// replaced by a better screen. Doesn't even need to be stateful
class SelectorScreen extends ConsumerStatefulWidget {
  const SelectorScreen({super.key});
  @override
  ConsumerState<SelectorScreen> createState() => _SelectorScreenState();
}

class _SelectorScreenState extends ConsumerState<SelectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            Zip? file = await FileReader().selectZip();
            if (file == null) {
              return;
            }
            ref.read(readerProvider.notifier).loadManga(file);
            ref.read(ocrProvider.notifier).clearResult();

            // This checks if this Widget still exists after the await from
            // FileReader, making sure Navigator doesn't execute if the
            // Widget have been dismounted (e.g. user clicks back)
            if (!context.mounted) return;

            Navigator.pushNamed(context, "/reader");
          },
          child: const Text("Select Zip File"),
        ),
      ),
    );
  }
}
