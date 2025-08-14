import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

import '../../data/datasources/user_jadwal_pasien_remote_datasource.dart';
import '../../data/repositories/user_jadwal_pasien_repository_impl.dart';
import '../../domain/entities/user_jadwal_pasien.dart';
import '../../domain/repositories/user_jadwal_pasien_repository.dart';

class UserJadwalPasienState {
  final List<UserJadwalPasien>? jadwalPasien;
  final bool isLoading;
  final String? error;

  UserJadwalPasienState({
    this.jadwalPasien = const [],
    this.isLoading = false,
    this.error,
  });

  UserJadwalPasienState copyWith({
    List<UserJadwalPasien>? jadwalPasien,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return UserJadwalPasienState(
      jadwalPasien: jadwalPasien ?? this.jadwalPasien,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final userJadwalPasienRemoteDataSourceProvider =
    Provider<UserJadwalPasienRemoteDataSource>(
      (ref) => UserJadwalPasienRemoteDataSourceImpl(ref.watch(dioProvider)),
    );

final userJadwalPasienRepositoryProvider = Provider<UserJadwalPasienRepository>(
  (ref) => UserJadwalPasienRepositoryImpl(
    ref.watch(userJadwalPasienRemoteDataSourceProvider),
  ),
);

// ==============================
// INI JADWAL TERAPI
// ==============================

class UserJadwalTerapiPasienViewModel extends Notifier<UserJadwalPasienState> {
  @override
  UserJadwalPasienState build() {
    Future.microtask(fetchUserJadwalTerapiPasien);
    return UserJadwalPasienState(isLoading: true);
  }

  UserJadwalPasienRepository get _repository =>
      ref.read(userJadwalPasienRepositoryProvider);

  Future<void> fetchUserJadwalTerapiPasien() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (jadwalPasien, failure) = await _repository
        .getAllJadwalTerapiPasien();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(jadwalPasien: jadwalPasien, isLoading: false);
    }
  }
}

final userJadwalTerapiViewModel =
    NotifierProvider<UserJadwalTerapiPasienViewModel, UserJadwalPasienState>(
      () => UserJadwalTerapiPasienViewModel(),
    );

// ==============================
// INI JADWAL AMBIL OBAT
// ==============================

class UserJadwalAmbilObatPasienViewModel
    extends Notifier<UserJadwalPasienState> {
  @override
  UserJadwalPasienState build() {
    Future.microtask(fetchUserJadwalAmbilObatPasien);
    return UserJadwalPasienState(isLoading: true);
  }

  UserJadwalPasienRepository get _repository =>
      ref.read(userJadwalPasienRepositoryProvider);

  Future<void> fetchUserJadwalAmbilObatPasien() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (jadwalPasien, failure) = await _repository
        .getAllJadwalAmbilObatPasien();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(jadwalPasien: jadwalPasien, isLoading: false);
    }
  }
}

final userJadwalAmbilObatViewModel =
    NotifierProvider<UserJadwalAmbilObatPasienViewModel, UserJadwalPasienState>(
      () => UserJadwalAmbilObatPasienViewModel(),
    );
