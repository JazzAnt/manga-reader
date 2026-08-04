import 'package:flutter/material.dart';
import 'package:manga_reader/models/dictionary_definition.dart';
import 'package:manga_reader/models/dictionary_entry.dart';

class DictionaryDisplay extends StatelessWidget {
  const DictionaryDisplay({super.key, required this.dictionaryEntry});
  final DictionaryEntry dictionaryEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            dictionaryEntry.word,
            style: TextStyle(fontSize: 18, fontWeight: .w700),
          ),
          Text(
            dictionaryEntry.reading,
            style: TextStyle(fontSize: 15, fontWeight: .w500),
          ),
          Column(
            children: [
              for (int i = 0; i < dictionaryEntry.definitions.length; i++)
                DefinitionDisplay(
                  index: i,
                  dictionaryDefinition: dictionaryEntry.definitions[i],
                ),
            ],
          ),
        ],
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
      decoration: BoxDecoration(
        color: Colors.greenAccent,
        border: Border.all(color: Colors.black, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: .circular(15),
            ),
            child: Text(
              dictionaryDefinition.pos,
              style: TextStyle(color: Colors.white),
            ),
          ),
          Column(
            children: dictionaryDefinition.definitions
                .map((definition) => Text("- $definition"))
                .toList(),
          ),
          Text(
            dictionaryDefinition.info.isNotEmpty
                ? "Info:${dictionaryDefinition.info}"
                : "",
            style: TextStyle(fontStyle: .italic),
          ),
        ],
      ),
    );
  }
}
