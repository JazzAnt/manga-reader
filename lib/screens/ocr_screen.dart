import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/dictionary_entry.dart';
import 'package:manga_reader/models/ocr_result.dart';
import 'package:manga_reader/providers/ocr_provider.dart';
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
  bool _lookingUp = false;
  List<DictionaryEntry> _entries = [];
  Timer? _selectionDelay;
  @override
  Widget build(BuildContext context) {
    final ocrResult = ref.watch(ocrProvider).value;
    final recognizedText = ocrResult?.text ?? "";
    return Padding(
      padding: .all(10),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent,
              border: .all(color: CupertinoColors.activeBlue, width: 2),
              borderRadius: .circular(6),
            ),
            child: SelectionArea(
              child: Text(
                recognizedText,
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              onSelectionChanged: (selection) {
                _selectionDelay?.cancel();

                final keyword = selection?.plainText;
                if (keyword == null || keyword.isEmpty) {
                  setState(() {
                    _entries = [];
                    _placeholderText = "Awaiting Selection";
                    _lookingUp = false;
                  });
                  return;
                }

                setState(() {
                  _entries = []; // To remove previous entries.
                  _placeholderText = "Looking up 「$keyword」";
                  _lookingUp = true;
                });

                // Selection finalized if selection has stopped for more than 350ms
                _selectionDelay = Timer(
                  const Duration(milliseconds: 350),
                  () async {
                    final entries = await DictionaryService().lookup(keyword);
                    if (!mounted) return;

                    setState(() {
                      _entries = entries;
                      _placeholderText = _entries.isEmpty
                          ? "Cannot find definition of 「$keyword」"
                          : "Awaiting Selection";
                      _lookingUp = false;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: _entries.isNotEmpty
                ? ListView.builder(
                    itemCount: _entries.length,
                    itemBuilder: (context, index) {
                      return DictionaryDisplay(
                        dictionaryEntry: _entries[index],
                      );
                    },
                  )
                : Column(
                    mainAxisAlignment: .center,
                    children: [
                      Text(
                        _placeholderText,
                        style: TextStyle(fontWeight: .bold, fontSize: 30),
                      ),
                      SizedBox(height: 11),
                      _lookingUp
                          ? CircularProgressIndicator(
                              strokeWidth: 10,
                              color: Colors.green,
                            )
                          : SizedBox(),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
