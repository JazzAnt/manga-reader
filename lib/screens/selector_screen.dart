import 'package:flutter/material.dart';

import '../models/zip.dart';
import '../services/manga/file_reader.dart';
import '../services/manga/zip_handler.dart';

/// Has a button that opens a file picker and redirects to reader screen.
/// Mostly placeholder screen for testing, will either be updated or
/// replaced by a better screen.
class SelectorScreen extends StatefulWidget {
  const SelectorScreen({super.key});
  @override
  State<StatefulWidget> createState() => _SelectorScreenState();
}

class _SelectorScreenState extends State<SelectorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () async {
              Zip? file = await FileReader().selectZip();
              if (file == null){
                return;
              }
              final manga = ZipHandler().zipToManga(file);
              Navigator.pushNamed(context, "/reader", arguments: manga);
            },
            child: const Text("TEST")),
      ),
    );
  }

}