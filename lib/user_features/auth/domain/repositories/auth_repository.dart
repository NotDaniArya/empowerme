import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';

abstract class AuthRepository {
  Future<(Auth?, Failure?)> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<(Auth?, Failure?)> login({
    required String email,
    required String password,
  });

  Future<(Auth?, Failure?)> getCurrentUser();

  Future<(void, Failure?)> logout();
}
