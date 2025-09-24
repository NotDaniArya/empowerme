import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/edukasi/data/models/berita_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class BeritaRemoteDataSource {
  Future<List<BeritaModel>> getBeritaList();

  Future<void> postBerita({
    required String title,
    required String author,
    required String description,
    required String publishedDate,
    required String url,
  });
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

  @override
  Future<void> postBerita({
    required String title,
    required String author,
    required String description,
    required String publishedDate,
    required String url,
  }) async {
    try {
      await dio.post(
        '${TTexts.baseUrl}/news/article/saved',
        data: {
          "title": title,
          "author": author,
          "description": description,
          "urlToImage": 'empty',
          "publishedAt": publishedDate,
          "url": url,
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal menambah berita';
      if (e.response != null) {
        errorMessage =
            'Gagal menambah data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
