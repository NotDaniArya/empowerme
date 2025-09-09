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
