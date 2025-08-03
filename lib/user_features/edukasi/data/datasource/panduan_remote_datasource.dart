import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/edukasi/data/models/panduan_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class PanduanRemoteDataSource {
  Future<List<PanduanModel>> getPanduanList();
}

class PanduanRemoteDataSourceImpl implements PanduanRemoteDataSource {
  final Dio dio;

  const PanduanRemoteDataSourceImpl(this.dio);

  @override
  Future<List<PanduanModel>> getPanduanList() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/guide');

      final List<dynamic> listPanduan = response.data['data']['items'];

      return listPanduan
          .map((panduan) => PanduanModel.fromJson(panduan))
          .toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list panduan';
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
