import 'dart:async';
import 'dart:isolate';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:manga_reader/models/zip.dart';

import '../models/manga.dart';
import '../services/manga/zip_handler.dart';

/// Provides data, mainly for Reader Screen
final readerProvider = AsyncNotifierProvider<ReaderNotifier, ReaderState?>(
  ReaderNotifier.new,
);

/// Holds data for reader provider
class ReaderNotifier extends AsyncNotifier<ReaderState?> {
  @override
  FutureOr<ReaderState?> build() {
    // Initial value is null because user haven't opened a manga file.
    return null;
  }

  /// Loads the manga to the reader notifier.
  Future<void> loadManga(Zip zipFile) async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      // Isolate to not freeze the UI while parsing
      final manga = await Isolate.run(() => ZipHandler().zipToManga(zipFile));
      return ReaderState(manga: manga, currentIndex: 0);
    });
  }

  /// Changes the current index.
  void setIndex(int index) {
    final reader = state.value;
    if (reader == null) return;
    state = AsyncData(reader.copyWith(currentIndex: index));
  }

  /// Returns true if the argument is within the bounds of the manga page count.
  bool isIndexWithinBounds(int index) {
    final reader = state.value;
    if (reader == null) return false;
    return reader.currentIndex >= 0 ||
        reader.currentIndex < reader.manga.pageCount;
  }

  /// Returns true if currentIndex is above 0 (and reader is not null).
  bool canGoPrevious() {
    final reader = state.value;
    if (reader == null) return false;
    return reader.currentIndex > 0;
  }

  /// Returns true if currentIndex is below the max (and reader is not null)
  bool canGoNext() {
    final reader = state.value;
    if (reader == null) return false;
    return reader.currentIndex < reader.manga.pageCount - 1;
  }
}

/// Custom state class for our provider
class ReaderState {
  final Manga manga;
  final int currentIndex;

  const ReaderState({required this.manga, required this.currentIndex});

  // state.copyWith used to set a new state. We need this because variables are
  // immutable (final) so it needs to be recreated (can't just be set)
  ReaderState copyWith({Manga? manga, int? currentIndex}) {
    return ReaderState(
      manga: manga ?? this.manga,
      currentIndex: currentIndex ?? this.currentIndex,
    );
  }
}
