import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/zip.dart';

import '../models/manga.dart';
import '../services/manga/file_reader.dart';
import '../services/manga/zip_handler.dart';

final readerProvider =
  AsyncNotifierProvider<ReaderNotifier, ReaderState?>(ReaderNotifier.new);

class ReaderNotifier extends AsyncNotifier<ReaderState?>{
  @override
  FutureOr<ReaderState?> build() {
    // Initial value is null because user haven't opened a manga file.
    return null;
  }

  Future<void> loadManga() async {
    // Tell notifier that data is being loaded
    state = const AsyncLoading();

    final Zip? file = await FileReader().selectZip();
    if (file == null) {
      // If fail, data is null
      state = const AsyncData(null);
      return;
    }

    final manga = ZipHandler().zipToManga(file);

    // If success, data is read zip.
    state = AsyncData(
      ReaderState(
        manga: manga,
        currentIndex: 0,
      )
    );
  }
//TODO: look up reader.when(loading, error, data)
//TODO: look up AsyncLoading().copyWithPrevious(state)
}

/// Custom state class for our provider
class ReaderState {
  final Manga manga;
  final int currentIndex;

  const ReaderState({required this.manga, required this.currentIndex});

  // state.copyWith used to set a new state. We need this because variables are
  // immutable (final) so it needs to be recreated (can't just be set)
  ReaderState copyWith({Manga? manga, int? currentIndex}){
    return ReaderState(
        manga: manga ?? this.manga,
        currentIndex: currentIndex ?? this.currentIndex
    );
  }
}
