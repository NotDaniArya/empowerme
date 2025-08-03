import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/data/datasource/berita_remote_datasource.dart';
import 'package:new_empowerme/user_features/edukasi/data/repositories/berita_repository_impl.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/berita.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/berita_repository.dart';

import '../../../../../utils/shared_providers/provider.dart';

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
