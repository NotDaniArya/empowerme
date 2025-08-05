import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<(void, Failure?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<(void, Failure?)> verifyOtp({
    required String email,
    required String otp,
  });

  Future<(Auth?, Failure?)> login({
    required String email,
    required String password,
  });

  Future<(Auth?, Failure?)> getCurrentUser();

  Future<(void, Failure?)> logout();
}
