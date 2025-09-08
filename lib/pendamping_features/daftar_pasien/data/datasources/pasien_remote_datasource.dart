import 'package:dio/dio.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/data/model/pasien_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class PasienRemoteDataSource {
  Future<List<PasienModel>> getAllPasien();

  Future<void> updateStatus({required String id});
}

class PasienRemoteDataSourceImpl implements PasienRemoteDataSource {
  final Dio dio;

  const PasienRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PasienModel>> getAllPasien() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/patients');

      final List<dynamic> listPasien = response.data['data'];

      return listPasien.map((pasien) => PasienModel.fromJson(pasien)).toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list pasien';
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
  Future<void> updateStatus({required String id}) async {
    try {
      await dio.put('${TTexts.baseUrl}/update?id=$id');
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengubah status pasien';
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
