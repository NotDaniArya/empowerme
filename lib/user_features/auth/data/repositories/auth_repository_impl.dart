import 'package:new_empowerme/user_features/auth/data/datasources/auth_local_datasource.dart';
import 'package:new_empowerme/user_features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:new_empowerme/user_features/auth/domain/repositories/auth_repository.dart';

import '../../../../core/failure.dart';
import '../../domain/entities/auth.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<(void, Failure?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        passwordConfirm: passwordConfirm,
      );
      return (null, null);
    } catch (e) {
      return (null, Failure('Register gagal: ${e.toString()}'));
    }
  }

  @override
  Future<(void, Failure?)> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      await remoteDataSource.verifyOtp(email: email, otp: otp);
      return (null, null);
    } catch (e) {
      return (null, Failure('Verifikasi OTP gagal: ${e.toString()}'));
    }
  }

  @override
  Future<(Auth?, Failure?)> login({
    required String email,
    required String password,
  }) async {
    try {
      final authModel = await remoteDataSource.login(
        email: email,
        password: password,
      );

      await localDataSource.saveAuthData(
        authModel.token,
        authModel.role.name,
        authModel.id,
      );

      return (authModel, null);
    } catch (e) {
      return (null, Failure('Login gagal: ${e.toString()}'));
    }
  }

  @override
  Future<(Auth?, Failure?)> getCurrentUser() async {
    try {
      final token = await localDataSource.getToken();
      final role = await localDataSource.getRole();
      final id = await localDataSource.getId();

      if (token != null && role != null && id != null) {
        final entity = Auth(token: token, role: _parseRole(role), id: id);

        return (entity, null);
      } else {
        return (null, null);
      }
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> logout() async {
    try {
      await localDataSource.clearAuthData();
      return (null, null);
    } catch (e) {
      return (null, const Failure('Gagal logout'));
    }
  }

  @override
  Future<(void, Failure?)> requestOtp({required String email}) async {
    try {
      await remoteDataSource.requestOtp(email: email);
      return (null, null);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  // function untuk mengubah string role menjadi Enum
  UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'pasien':
        return UserRole.pasien;
      case 'konselor':
        return UserRole.konselor;
      case 'pendamping':
        return UserRole.pendamping;
      default:
        return UserRole.unknown;
    }
  }
}
