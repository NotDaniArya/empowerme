import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/providers/pasien_provider.dart';
import 'package:new_empowerme/pendamping_features/dashboard/presentation/providers/dashboard_provider.dart';
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

// ======================================
// INI JADWAL TERAPI PASIEN
// ======================================

class JadwalTerapiPasienViewModel
    extends FamilyNotifier<JadwalPasienState, String> {
  @override
  JadwalPasienState build(String category) {
    _fetchJadwalPasienList();
    return JadwalPasienState(isLoading: true);
  }

  Future<void> _fetchJadwalPasienList() async {
    final (jadwalPasien, failure) = await ref
        .read(jadwalPasienRepositoryProvider)
        .getAllJadwalTerapiPasien(category: arg);

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(jadwalPasien: jadwalPasien, isLoading: false);
    }
  }
}

final jadwalTerapiPasienViewModel =
    NotifierProvider.family<
      JadwalTerapiPasienViewModel,
      JadwalPasienState,
      String
    >(() => JadwalTerapiPasienViewModel());

// ======================================
// INI JADWAL AMBIL OBAT PASIEN
// ======================================

class JadwalAmbilObatPasienViewModel
    extends FamilyNotifier<JadwalPasienState, String> {
  @override
  JadwalPasienState build(String category) {
    _fetchJadwalPasienList();
    return JadwalPasienState(isLoading: true);
  }

  Future<void> _fetchJadwalPasienList() async {
    final (jadwalPasien, failure) = await ref
        .read(jadwalPasienRepositoryProvider)
        .getAllJadwalAmbilObatPasien(category: arg);

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(jadwalPasien: jadwalPasien, isLoading: false);
    }
  }
}

final jadwalAmbilObatPasienViewModel =
    NotifierProvider.family<
      JadwalAmbilObatPasienViewModel,
      JadwalPasienState,
      String
    >(() => JadwalAmbilObatPasienViewModel());

class JadwalPasienUpdater extends Notifier<bool> {
  @override
  bool build() {
    return false;
  }

  JadwalPasienRepository get _repository =>
      ref.read(jadwalPasienRepositoryProvider);

  Future<void> addJadwalTerapi({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.addJadwalTerapi(
        id: id,
        date: date,
        time: time,
        location: location,
        meetWith: meetWith,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(jadwalTerapiPasienViewModel);
        ref.invalidate(dashboardViewModel);
        ref.invalidate(pasienViewModel);

        onSuccess();
      }
    } finally {
      state = false;
    }
  }

  Future<void> addJadwalAmbilObat({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required String typeDrug,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.addJadwalAmbilObat(
        id: id,
        date: date,
        time: time,
        location: location,
        meetWith: meetWith,
        typeDrug: typeDrug,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(jadwalAmbilObatPasienViewModel);
        ref.invalidate(dashboardViewModel);
        ref.invalidate(pasienViewModel);

        onSuccess();
      }
    } finally {
      state = false;
    }
  }

  Future<void> updateStatusTerapi({
    required int idJadwal,
    required String status,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.updateStatusTerapi(
        status: status,
        idJadwal: idJadwal,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(jadwalTerapiPasienViewModel);
        ref.invalidate(dashboardViewModel);

        onSuccess();
      }
    } finally {
      state = false;
    }
  }

  Future<void> updateStatusAmbilObat({
    required int idJadwal,
    required String status,
    required VoidCallback onSuccess,
    required Function(String) onError,
  }) async {
    state = true;
    try {
      final (_, failure) = await _repository.updateStatusAmbilObat(
        status: status,
        idJadwal: idJadwal,
      );

      if (failure != null) {
        onError(failure.message);
      } else {
        ref.invalidate(jadwalAmbilObatPasienViewModel);
        ref.invalidate(dashboardViewModel);

        onSuccess();
      }
    } finally {
      state = false;
    }
  }
}

final jadwalPasienUpdaterProvider = NotifierProvider<JadwalPasienUpdater, bool>(
  () => JadwalPasienUpdater(),
);
