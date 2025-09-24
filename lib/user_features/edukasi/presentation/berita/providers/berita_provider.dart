import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/data/repositories/berita_repository_impl.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/berita.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/berita_repository.dart';

import '../../../../../utils/shared_providers/provider.dart';
import '../../../data/datasources/berita_remote_datasource.dart';

class BeritaState {
  final List<Berita>? berita;
  final bool isLoading;
  final String? error;

  BeritaState({this.berita = const [], this.isLoading = false, this.error});

  BeritaState copyWith({
    List<Berita>? berita,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return BeritaState(
      berita: berita ?? this.berita,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final beritaRemoteDataSourceProvider = Provider<BeritaRemoteDataSource>(
  (ref) => BeritaRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final beritaRepositoryProvider = Provider<BeritaRepository>(
  (ref) => BeritaRepositoryImpl(ref.watch(beritaRemoteDataSourceProvider)),
);

class BeritaViewModel extends Notifier<BeritaState> {
  @override
  BeritaState build() {
    Future.microtask(fetchBeritaList);
    return BeritaState(isLoading: true);
  }

  BeritaRepository get _repository => ref.read(beritaRepositoryProvider);

  Future<void> fetchBeritaList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (berita, failure) = await _repository.getBeritaList();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(berita: berita, isLoading: false);
    }
  }
}

final beritaViewModel = NotifierProvider<BeritaViewModel, BeritaState>(
  () => BeritaViewModel(),
);

class BeritaUpdater extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  BeritaRepository get _repository => ref.read(beritaRepositoryProvider);

  Future<void> postBerita({
    required String title,
    required String author,
    required String description,
    required String publishedDate,
    required String url,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.postBerita(
        title: title,
        author: author,
        description: description,
        publishedDate: publishedDate,
        url: url,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(beritaViewModel);
        onSuccess();
      }
    } finally {
      state = false;
    }
  }
}

final beritaUpdaterProvider = NotifierProvider<BeritaUpdater, bool>(
  () => BeritaUpdater(),
);
