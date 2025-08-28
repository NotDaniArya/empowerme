import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/profile/data/models/profile_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileModel> getProfile({required String id});
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
}
