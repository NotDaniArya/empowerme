import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/data/repositories/panduan_repository_impl.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/panduan.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/panduan_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

import '../../../data/datasources/panduan_remote_datasource.dart';

class PanduanState {
  final List<Panduan>? panduan;
  final bool isLoading;
  final String? error;

  PanduanState({this.panduan = const [], this.isLoading = false, this.error});

  PanduanState copyWith({
    List<Panduan>? panduan,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PanduanState(
      panduan: panduan ?? this.panduan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final panduanRemoteDataSourceProvider = Provider<PanduanRemoteDataSource>(
  (ref) => PanduanRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final panduanRepositoryProvider = Provider<PanduanRepository>(
  (ref) => PanduanRepositoryImpl(ref.watch(panduanRemoteDataSourceProvider)),
);

class PanduanViewModel extends Notifier<PanduanState> {
  @override
  PanduanState build() {
    Future.microtask(fetchPanduanList);
    return PanduanState(isLoading: true);
  }

  PanduanRepository get _repository => ref.read(panduanRepositoryProvider);

  Future<void> fetchPanduanList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (panduan, failure) = await _repository.getPanduanList();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(panduan: panduan, isLoading: false);
    }
  }
}

final panduanViewModel = NotifierProvider<PanduanViewModel, PanduanState>(
  () => PanduanViewModel(),
);

class PanduanUpdater extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  PanduanRepository get _repository => ref.read(panduanRepositoryProvider);

  Future<void> postPanduan({
    required String title,
    required String description,
    required String publishers,
    required String publishedDate,
    required String infoLink,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.postPanduan(
        title: title,
        description: description,
        publishers: publishers,
        publishedDate: publishedDate,
        infoLink: infoLink,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(panduanViewModel);
        onSuccess();
      }
    } finally {
      state = false;
    }
  }
}

final panduanUpdaterProvider = NotifierProvider<PanduanUpdater, bool>(
  () => PanduanUpdater(),
);
