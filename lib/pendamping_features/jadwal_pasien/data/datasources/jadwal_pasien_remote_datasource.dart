import 'package:dio/dio.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/model/jadwal_pasien_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class JadwalPasienRemoteDataSource {
  Future<List<JadwalPasienModel>> getAllJadwalPasien({
    required String category,
  });

  Future<void> updateStatusTerapi({
    required String status,
    required int idJadwal,
  });
}

class JadwalPasienRemoteDataSourceImpl implements JadwalPasienRemoteDataSource {
  final Dio dio;

  const JadwalPasienRemoteDataSourceImpl(this.dio);

  @override
  Future<List<JadwalPasienModel>> getAllJadwalPasien({
    required String category,
  }) async {
    try {
      Response<dynamic> response;
      if (category == 'all') {
        response = await dio.get(
          '${TTexts.baseUrl}/histories/therapy/$category',
        );
      } else {
        response = await dio.get('${TTexts.baseUrl}/therapy/$category');
      }

      final List<dynamic> listJadwalPasien = response.data['data'];

      return listJadwalPasien
          .map((jadwalPasien) => JadwalPasienModel.fromJson(jadwalPasien))
          .toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list berita';
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
  Future<void> updateStatusTerapi({
    required String status,
    required int idJadwal,
  }) async {
    try {
      final response = await dio.put(
        '${TTexts.baseUrl}/therapy/update/status?id=$idJadwal',
        data: {'status': status},
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat mengubah status terapi';
      if (e.response != null) {
        errorMessage =
            'Gagal saat mengubah status terapi: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
