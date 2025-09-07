import 'dart:io';

import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/profile/data/models/profile_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';
import 'package:path/path.dart' as path;

import '../../../../core/failure.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String id});

  Future<void> updateProfilePicture({required File imageFile});

  Future<void> updateName({required String name});

  Future<void> updatePassword({
    required String passwordNew,
    required String passwordConfirm,
    required String passwordOld,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final Dio dio;

  const ProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<ProfileModel> getProfile({required String id}) async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/profile?id=$id');

      return ProfileModel.fromJson(response.data['data']);
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil profile pengguna';
      if (e.response != null) {
        errorMessage =
            'Gagal mengambil data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> updateName({required String name}) async {
    try {
      await dio.put('${TTexts.baseUrl}/update/name', data: {"name": name});
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengubah nama pengguna';
      if (e.response != null) {
        errorMessage =
            'Gagal mengubah data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> updatePassword({
    required String passwordNew,
    required String passwordConfirm,
    required String passwordOld,
  }) async {
    try {
      await dio.put(
        '${TTexts.baseUrl}/change/password',
        data: {
          "passwordNew": passwordNew,
          "passwordConfirm": passwordConfirm,
          "passwordOld": passwordOld,
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengubah nama pengguna';
      if (e.response != null) {
        errorMessage =
            'Gagal mengubah data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> updateProfilePicture({required File imageFile}) async {
    try {
      String fileName = path.basename(imageFile.path);

      FormData formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      await dio.put('${TTexts.baseUrl}/update/picture', data: formData);
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengubah foto profil pengguna';
      if (e.response != null) {
        errorMessage =
            'Gagal mengubah data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
