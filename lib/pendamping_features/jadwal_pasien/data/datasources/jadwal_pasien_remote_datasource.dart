import 'package:dio/dio.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/model/jadwal_pasien_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class JadwalPasienRemoteDataSource {
  Future<void> addJadwalTerapi({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
  });

  Future<void> addJadwalAmbilObat({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required String typeDrug,
  });

  Future<List<JadwalPasienModel>> getAllJadwalTerapiPasien({
    required String category,
  });

  Future<List<JadwalPasienModel>> getAllJadwalAmbilObatPasien({
    required String category,
  });

  Future<void> updateStatusTerapi({
    required String status,
    required int idJadwal,
  });

  Future<void> updateStatusAmbilObat({
    required String status,
    required int idJadwal,
  });
}

class JadwalPasienRemoteDataSourceImpl implements JadwalPasienRemoteDataSource {
  final Dio dio;

  const JadwalPasienRemoteDataSourceImpl(this.dio);

  @override
  Future<void> addJadwalTerapi({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
  }) async {
    try {
      final response = await dio.post(
        '${TTexts.baseUrl}/saved/therapy',
        data: {
          "idUser": id,
          "date": date,
          "time": time,
          "location": location,
          "meetWith": meetWith,
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat menambahkan jadwal terapi';
      if (e.response != null) {
        errorMessage =
            'Gagal saat menambahkan jadwal terapi: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> addJadwalAmbilObat({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required String typeDrug,
  }) async {
    try {
      final response = await dio.post(
        '${TTexts.baseUrl}/saved/drug',
        data: {
          "idUser": id,
          "date": date,
          "time": time,
          "location": location,
          "meetWith": meetWith,
          "typeDrug": typeDrug,
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat menambahkan jadwal ambil obat';
      if (e.response != null) {
        errorMessage =
            'Gagal saat menambahkan jadwal ambil obat: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<List<JadwalPasienModel>> getAllJadwalTerapiPasien({
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
  Future<List<JadwalPasienModel>> getAllJadwalAmbilObatPasien({
    required String category,
  }) async {
    try {
      Response<dynamic> response;
      if (category == 'all') {
        response = await dio.get(
          '${TTexts.baseUrl}/medication/histories/$category',
        );
      } else {
        response = await dio.get('${TTexts.baseUrl}/medication/$category');
      }

      final List<dynamic> listJadwalPasien = response.data['data'];

      return listJadwalPasien
          .map((jadwalPasien) => JadwalPasienModel.fromJson(jadwalPasien))
          .toList();
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

  @override
  Future<void> updateStatusAmbilObat({
    required String status,
    required int idJadwal,
  }) async {
    try {
      final response = await dio.put(
        '${TTexts.baseUrl}/medication/update/status?id=$idJadwal',
        data: {'status': status},
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal saat mengubah status ambil obat';
      if (e.response != null) {
        errorMessage =
            'Gagal saat mengubah status ambil obat: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
