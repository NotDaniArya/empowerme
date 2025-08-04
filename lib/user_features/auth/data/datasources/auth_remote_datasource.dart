import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/auth/data/models/auth_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  });

  Future<AuthModel> login({required String email, required String password});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  const AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthModel> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        '${TTexts.baseUrl}/login',
        data: {'email': email, 'password': password},
      );

      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat loin';
      if (e.response != null) {
        errorMessage =
            'Gagal saat login: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<AuthModel> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirm,
  }) async {
    try {
      final response = await dio.post(
        '${TTexts.baseUrl}/registration',
        data: {
          "name": name,
          "email": email,
          "password": password,
          "passwordConfirm": passwordConfirm,
        },
      );

      return AuthModel.fromJson(response.data);
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat register';
      if (e.response != null) {
        errorMessage =
            'Gagal saat register: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
