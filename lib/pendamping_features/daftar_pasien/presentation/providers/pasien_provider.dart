import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/datasources/pasien_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/repositories/pasien_repository_impl.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/repositories/pasien_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

class PasienState {
  final List<Pasien>? pasien;
  final bool isLoading;
  final String? error;

  PasienState({this.pasien = const [], this.isLoading = false, this.error});

  PasienState copyWith({
    List<Pasien>? pasien,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return PasienState(
      pasien: pasien ?? this.pasien,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final pasienRemoteDataSourceProvider = Provider<PasienRemoteDataSource>(
  (ref) => PasienRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final pasienRepositoryProvider = Provider<PasienRepository>(
  (ref) => PasienRepositoryImpl(ref.watch(pasienRemoteDataSourceProvider)),
);

class PasienViewModel extends Notifier<PasienState> {
  @override
  PasienState build() {
    Future.microtask(fetchPasienList);
    return PasienState(isLoading: true);
  }

  PasienRepository get _repository => ref.read(pasienRepositoryProvider);

  Future<void> fetchPasienList() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (pasien, failure) = await _repository.getAllPasien();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(pasien: pasien, isLoading: false);
    }
  }
}

final pasienViewModel = NotifierProvider<PasienViewModel, PasienState>(
  () => PasienViewModel(),
);
