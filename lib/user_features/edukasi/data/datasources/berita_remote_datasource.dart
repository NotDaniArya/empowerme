import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/edukasi/data/models/berita_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class BeritaRemoteDataSource {
  Future<List<BeritaModel>> getBeritaList();
}

class BeritaRemoteDataSourceImpl implements BeritaRemoteDataSource {
  final Dio dio;

  const BeritaRemoteDataSourceImpl(this.dio);

  @override
  Future<List<BeritaModel>> getBeritaList() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/news/article');

      final List<dynamic> listBerita = response.data['data']['articles'];

      return listBerita.map((berita) => BeritaModel.fromJson(berita)).toList();
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
}
