import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/data/repositories/makanan_repository_impl.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/makanan.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/makanan_repository.dart';

import '../../../../../utils/shared_providers/provider.dart';
import '../../../data/datasources/makanan_remote_datasource.dart';

class MakananState {
  final List<Makanan>? makanan;
  final bool isLoading;
  final String? error;

  MakananState({this.makanan = const [], this.isLoading = false, this.error});

  MakananState copyWith({
    List<Makanan>? makanan,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return MakananState(
      makanan: makanan ?? this.makanan,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final makananRemoteDataSourceProvider = Provider<MakananRemoteDataSource>(
  (ref) => MakananRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final makananRepositoryProvider = Provider<MakananRepository>(
  (ref) => MakananRepositoryImpl(ref.watch(makananRemoteDataSourceProvider)),
);

class MakananViewModel extends Notifier<MakananState> {
  @override
  MakananState build() {
    Future.microtask(fetchMakananList);
    return MakananState(isLoading: true);
  }

  MakananRepository get _repository => ref.read(makananRepositoryProvider);

  Future<void> fetchMakananList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (makanan, failure) = await _repository.getMakanan();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(makanan: makanan, isLoading: false);
    }
  }
}

final makananViewModel = NotifierProvider<MakananViewModel, MakananState>(
  () => MakananViewModel(),
);

class MakananUpdater extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  MakananRepository get _repository => ref.read(makananRepositoryProvider);

  Future<void> postMakanan({
    required String link,
    required String title,
    required String source,
    required String date,
    required String description,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.postMakanan(
        link: link,
        title: title,
        source: source,
        date: date,
        description: description,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(makananViewModel);
        onSuccess();
      }
    } finally {
      state = false;
    }
  }
}

final makananUpdaterProvider = NotifierProvider<MakananUpdater, bool>(
  () => MakananUpdater(),
);
