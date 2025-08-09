import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/datasources/jadwal_pasien_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/repositories/jadwal_pasien_repository_impl.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/repositories/jadwal_pasien_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

class JadwalPasienState {
  final List<JadwalPasien>? jadwalPasien;
  final bool isLoading;
  final String? error;

  JadwalPasienState({
    this.jadwalPasien = const [],
    this.isLoading = false,
    this.error,
  });

  JadwalPasienState copyWith({
    List<JadwalPasien>? jadwalPasien,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return JadwalPasienState(
      jadwalPasien: jadwalPasien ?? this.jadwalPasien,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final jadwalPasienRemoteDataSourceProvider =
    Provider<JadwalPasienRemoteDataSource>(
      (ref) => JadwalPasienRemoteDataSourceImpl(ref.watch(dioProvider)),
    );

final jadwalPasienRepositoryProvider = Provider<JadwalPasienRepository>(
  (ref) => JadwalPasienRepositoryImpl(
    ref.watch(jadwalPasienRemoteDataSourceProvider),
  ),
);

class JadwalPasienViewModel extends FamilyNotifier<JadwalPasienState, String> {
  @override
  JadwalPasienState build(String category) {
    _fetchJadwalPasienList();
    return JadwalPasienState(isLoading: true);
  }

  Future<void> _fetchJadwalPasienList() async {
    final (jadwalPasien, failure) = await ref
        .read(jadwalPasienRepositoryProvider)
        .getAllJadwalPasien(category: arg);

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(jadwalPasien: jadwalPasien, isLoading: false);
    }
  }
}

final jadwalPasienViewModel =
    NotifierProvider.family<JadwalPasienViewModel, JadwalPasienState, String>(
      () => JadwalPasienViewModel(),
    );

class JadwalPasienUpdater extends Notifier<void> {
  @override
  void build() {}

  JadwalPasienRepository get _repository =>
      ref.read(jadwalPasienRepositoryProvider);

  Future<void> updateStatus({
    required int idJadwal,
    required String status,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    final (_, failure) = await _repository.updateStatusTerapi(
      status: status,
      idJadwal: idJadwal,
    );

    if (failure != null) {
      onError(failure.message);
    } else {
      ref.invalidate(jadwalPasienViewModel);

      onSuccess();
    }
  }
}

final jadwalPasienUpdaterProvider = NotifierProvider<JadwalPasienUpdater, void>(
  () => JadwalPasienUpdater(),
);
