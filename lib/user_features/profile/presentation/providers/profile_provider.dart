import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:new_empowerme/user_features/profile/data/repositories/profile_repository_impl.dart';
import 'package:new_empowerme/user_features/profile/domain/entities/profile.dart';
import 'package:new_empowerme/user_features/profile/domain/repositories/profile_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileState {
  final Profile? profile;
  final bool isLoading;
  final String? error;

  ProfileState({this.profile, this.isLoading = false, this.error});

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final profileRepositoryProvider = Provider<ProfileRepository>(
  (ref) => ProfileRepositoryImpl(ref.watch(profileRemoteDataSourceProvider)),
);

class ProfileViewModel extends Notifier<ProfileState> {
  @override
  ProfileState build() {
    _fetchProfile();
    return ProfileState(isLoading: true);
  }

  ProfileRepository get _repository => ref.read(profileRepositoryProvider);

  AuthLocalDataSource get _authDataSource =>
      ref.read(authLocalDataSourceProvider);

  Future<void> _fetchProfile() async {
    try {
      // 1. Ambil ID pengguna dari local data source
      final id = await _authDataSource.getId();

      // 2. Lakukan null check untuk memastikan ID ada
      if (id == null) {
        // Jika tidak ada ID, berarti pengguna belum login. Set state error.
        state = state.copyWith(
          isLoading: false,
          error: 'Pengguna tidak ditemukan. Silakan login ulang.',
        );
        return;
      }

      // 3. Panggil repository dengan ID yang sudah didapat
      final (profile, failure) = await _repository.getProfile(id: id);

      if (failure != null) {
        state = state.copyWith(isLoading: false, error: failure.message);
      } else {
        state = state.copyWith(profile: profile, isLoading: false);
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final profileViewModel = NotifierProvider<ProfileViewModel, ProfileState>(
  () => ProfileViewModel(),
);
