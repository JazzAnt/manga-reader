import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:manga_reader/models/dictionary_definition.dart';
import 'package:manga_reader/models/dictionary_entry.dart';

/// Widget to display DictionaryEntry data.
class DictionaryDisplay extends StatelessWidget {
  const DictionaryDisplay({super.key, required this.dictionaryEntry});
  final DictionaryEntry dictionaryEntry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(5),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Wrap(
              children: [
                Text(
                  dictionaryEntry.word,
                  style: TextStyle(fontSize: 25, fontWeight: .bold),
                ),
                Text(
                  "（${dictionaryEntry.reading}）",
                  style: TextStyle(fontSize: 22, fontWeight: .w700),
                ),
              ],
            ),

            Column(
              children: [
                for (int i = 0; i < dictionaryEntry.definitions.length; i++)
                  Padding(
                    padding: EdgeInsetsGeometry.fromLTRB(10, 0, 10, 4),
                    child: DefinitionDisplay(
                      index: i,
                      dictionaryDefinition: dictionaryEntry.definitions[i],
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DefinitionDisplay extends StatelessWidget {
  final int index;
  final DictionaryDefinition dictionaryDefinition;

  const DefinitionDisplay({
    super.key,
    required this.index,
    required this.dictionaryDefinition,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(12, 5, 12, 5),
        child: Stack(
          children: [
            Align(
              alignment: .topRight,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: .circular(5),
                ),
                child: Padding(
                  padding: .all(5),
                  child: Text(
                    dictionaryDefinition.pos,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: .bold,
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: .topLeft,
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Column(
                    crossAxisAlignment: .start,
                    children: dictionaryDefinition.definitions
                        .map((definition) => Text("- $definition"))
                        .toList(),
                  ),
                  SizedBox(height: 8),
                  dictionaryDefinition.info.isNotEmpty
                      ? Container(
                          decoration: BoxDecoration(
                            color: CupertinoColors.lightBackgroundGray,
                            border: Border.all(color: Colors.black, width: 1),
                            borderRadius: .circular(5),
                          ),
                          child: Padding(
                            padding: .all(5),
                            child: Text(
                              "Note: ${dictionaryDefinition.info}",
                              style: TextStyle(color: Colors.black87),
                            ),
                          ),
                        )
                      : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
