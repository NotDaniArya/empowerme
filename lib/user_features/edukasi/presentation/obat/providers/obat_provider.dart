import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/data/repositories/obat_repository_impl.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';

import '../../../../../utils/shared_providers/provider.dart';
import '../../../data/datasources/obat_remote_datasource.dart';
import '../../../domain/repositories/obat_repository.dart';

class ObatState {
  final List<Obat>? obat;
  final bool isLoading;
  final String? error;

  ObatState({this.obat = const [], this.isLoading = false, this.error});

  ObatState copyWith({
    List<Obat>? obat,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ObatState(
      obat: obat ?? this.obat,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final obatRemoteDataSourceProvider = Provider<ObatRemoteDataSource>(
  (ref) => ObatRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final obatRepositoryProvider = Provider<ObatRepository>(
  (ref) => ObatRepositoryImpl(ref.watch(obatRemoteDataSourceProvider)),
);

class ObatViewModel extends Notifier<ObatState> {
  @override
  ObatState build() {
    Future.microtask(fetchObatList);
    return ObatState(isLoading: true);
  }

  ObatRepository get _repository => ref.read(obatRepositoryProvider);

  Future<void> fetchObatList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (obat, failure) = await _repository.getObat();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(obat: obat, isLoading: false);
    }
  }
}

final obatViewModel = NotifierProvider<ObatViewModel, ObatState>(
  () => ObatViewModel(),
);

class ObatUpdater extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  ObatRepository get _repository => ref.read(obatRepositoryProvider);

  Future<void> postObat({
    required String title,
    required String source,
    required String date,
    required String snippet,
    required String link,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.postObat(
        title: title,
        source: source,
        date: date,
        snippet: snippet,
        link: link,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(obatViewModel);
        onSuccess();
      }
    } finally {
      state = false;
    }
  }
}

final obatUpdaterProvider = NotifierProvider<ObatUpdater, bool>(
  () => ObatUpdater(),
);
