import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/dictionary_entry.dart';
import 'package:manga_reader/services/dictionary/dictionary_service.dart';
import 'package:manga_reader/widgets/DictionaryDisplay.dart';

/// This is a placeholder to be placed where the OCR screen will be eventually
class OcrScreen extends ConsumerStatefulWidget {
  const OcrScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OcrScreenState();
}

class _OcrScreenState extends ConsumerState<OcrScreen> {
  String _placeholderText = "Awaiting Selection";
  List<DictionaryEntry> _entries = [];
  Timer? _selectionDelay;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectionArea(
          child: Text( //TODO: replace with actual OCR text
            "私はばかです。でもあなたよりもっとばかすぎる。お前はせかいいちばかにんげん。ばかばかばか",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
          onSelectionChanged: (selection) {
            _selectionDelay?.cancel();

            final keyword = selection?.plainText;
            if (keyword == null || keyword.isEmpty) {
              setState(() {
                _entries = [];
                _placeholderText = "Awaiting Selection";
              });
              return;
            }

            setState(() {
              _entries = []; // To remove previous entries.
              _placeholderText = "Looking up $keyword";
            });

            // Selection finalized if selection has stopped for more than 350ms
            _selectionDelay = Timer(
              const Duration(milliseconds: 350),
              () async {
                print("Starting entry lookup");
                final entries = await DictionaryService().lookup(keyword);
                print("Ending entry lookup");
                if (!mounted) return;
                setState(() {
                  _entries = entries;
                });
              },
            );
          },
        ),
        Expanded(
          child: _entries.isNotEmpty
              ? ListView.builder(
                  itemCount: _entries.length,
                  itemBuilder: (context, index) {
                    return DictionaryDisplay(dictionaryEntry: _entries[index]);
                  },
                )
              : Center(child: Text(_placeholderText)),
        ),
      ],
    );
  }
}
