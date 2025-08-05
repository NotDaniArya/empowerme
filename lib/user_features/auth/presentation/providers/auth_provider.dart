import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:new_empowerme/user_features/auth/data/datasources/auth_local_datasource.dart';
import 'package:new_empowerme/user_features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:new_empowerme/user_features/auth/data/repositories/auth_repository_impl.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';
import 'package:new_empowerme/user_features/auth/domain/repositories/auth_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final secureStorageProvider = Provider((ref) => const FlutterSecureStorage());

final sharedPrefsProvider = FutureProvider(
  (ref) async => await SharedPreferences.getInstance(),
);

final authLocalDataSourceProvider = Provider<AuthLocalDataSource>((ref) {
  final prefs = ref.watch(sharedPrefsProvider).value;
  final storage = ref.watch(secureStorageProvider);

  if (prefs == null) {
    throw Exception("SharedPreferences not initialized");
  }

  return AuthLocalDataSourceImpl(storage, prefs);
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final prefs = ref.watch(sharedPrefsProvider).value;
  final storage = ref.watch(secureStorageProvider);
  final dio = ref.watch(dioProvider);

  if (prefs == null) {
    throw Exception("SharedPreferences not initialized yet");
  }

  final localDataSource = AuthLocalDataSourceImpl(storage, prefs);
  final remoteDataSource = AuthRemoteDataSourceImpl(dio);

  return AuthRepositoryImpl(remoteDataSource, localDataSource);
});

class AuthNotifier extends StateNotifier<AsyncValue<Auth?>> {
  final Ref _ref;

  AuthNotifier(this._ref) : super(const AsyncValue.loading()) {
    _ref.watch(sharedPrefsProvider).whenData((_) {
      _checkCurrentUser();
    });
  }

  Future<void> _checkCurrentUser() async {
    final repository = _ref.read(authRepositoryProvider);

    final (user, failure) = await repository.getCurrentUser();

    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(user);
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    state = const AsyncValue.loading();

    final repository = _ref.read(authRepositoryProvider);

    final (_, failure) = await repository.register(
      name: name,
      email: email,
      password: password,
      passwordConfirm: passwordConfirm,
    );

    if (mounted) {
      if (failure != null) {
        state = AsyncValue.error(failure, StackTrace.current);
      } else {
        state = const AsyncValue.data(null);
      }
    }
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final (_, failure) = await repository.verifyOtp(email: email, otp: otp);

    if (mounted) {
      if (failure != null) {
        state = AsyncValue.error(failure, StackTrace.current);
      } else {
        state = const AsyncValue.data(null);
      }
    }
  }

  Future<void> login({required String email, required String password}) async {
    state = const AsyncValue.loading();
    final repository = _ref.read(authRepositoryProvider);

    final (user, failure) = await repository.login(
      email: email,
      password: password,
    );

    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(user);
    }
  }

  Future<void> logout() async {
    final repository = _ref.read(authRepositoryProvider);
    await repository.logout();
    state = const AsyncValue.data(null);
  }
}

final authNotifierProvider =
    StateNotifierProvider<AuthNotifier, AsyncValue<Auth?>>((ref) {
      return AuthNotifier(ref);
    });
