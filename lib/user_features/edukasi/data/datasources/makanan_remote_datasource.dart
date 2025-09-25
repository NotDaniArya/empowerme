import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/edukasi/data/models/makanan_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class MakananRemoteDataSource {
  Future<List<MakananModel>> getMakanan();

  Future<void> postMakanan({
    required String link,
    required String title,
    required String source,
    required String date,
    required String description,
  });
}

class MakananRemoteDataSourceImpl implements MakananRemoteDataSource {
  final Dio dio;

  const MakananRemoteDataSourceImpl(this.dio);

  @override
  Future<List<MakananModel>> getMakanan() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/food');

      final List<dynamic> listMakanan = response.data['data']['news_results'];

      return listMakanan
          .map((makanan) => MakananModel.fromJson(makanan))
          .toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list makanan';
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
  Future<void> postMakanan({
    required String link,
    required String title,
    required String source,
    required String date,
    required String description,
  }) async {
    try {
      await dio.post(
        '${TTexts.baseUrl}/food',
        data: {
          "link": link,
          "title": title,
          "source": source,
          "date": date,
          "snippet": description,
          "published_at": 'pendamping',
          "favicon": 'pendamping',
          "thumbnail": 'pendamping',
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal menambah edukasi makanan';
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
