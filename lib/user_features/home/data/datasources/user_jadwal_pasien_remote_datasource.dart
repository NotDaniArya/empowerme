import 'package:dio/dio.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';
import '../model/user_jadwal_pasien_model.dart';

abstract class UserJadwalPasienRemoteDataSource {
  Future<List<UserJadwalPasienModel>> getAllJadwalTerapiPasien({
    required String id,
  });

  Future<List<UserJadwalPasienModel>> getAllJadwalAmbilObatPasien({
    required String id,
  });
}

class UserJadwalPasienRemoteDataSourceImpl
    implements UserJadwalPasienRemoteDataSource {
  final Dio dio;

  const UserJadwalPasienRemoteDataSourceImpl(this.dio);

  @override
  Future<List<UserJadwalPasienModel>> getAllJadwalTerapiPasien({
    required String id,
  }) async {
    try {
      final response = await dio.get(
        '${TTexts.baseUrl}/histories/therapy?idUser=$id',
      );

      final Map<String, dynamic> dataJson = response.data['data'];

      return UserJadwalPasienModel.fromJsonList(dataJson);
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list jadwal terapi pasien';
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
  Future<List<UserJadwalPasienModel>> getAllJadwalAmbilObatPasien({
    required String id,
  }) async {
    try {
      final response = await dio.get(
        '${TTexts.baseUrl}/histories/medication?idUser=$id',
      );

      final Map<String, dynamic> dataJson = response.data['data'];

      return UserJadwalPasienModel.fromJsonList(dataJson);
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list jadwal ambil obat pasien';
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
