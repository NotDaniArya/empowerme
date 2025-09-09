import 'package:dio/dio.dart';

import '../../../../core/failure.dart';
import '../../../../utils/constant/texts.dart';
import '../models/obat_model.dart';

abstract class ObatRemoteDataSource {
  Future<List<ObatModel>> getObat();
}

class ObatRemoteDataSourceImpl implements ObatRemoteDataSource {
  final Dio dio;

  const ObatRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ObatModel>> getObat() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/news/medication');

      final List<dynamic> listObat = response.data['data']['news_results'];

      return listObat.map((obat) => ObatModel.fromJson(obat)).toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list obat';
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
