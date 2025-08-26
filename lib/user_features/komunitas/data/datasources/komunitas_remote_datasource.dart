import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/comment_model.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/komunitas_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class KomunitasRemoteDataSource {
  Future<List<KomunitasModel>> getCommunityPosts();

  Future<List<CommentModel>> getCommunityComment({required String id});
}

class KomunitasRemoteDataSourceImpl implements KomunitasRemoteDataSource {
  final Dio dio;

  const KomunitasRemoteDataSourceImpl(this.dio);

  @override
  Future<List<KomunitasModel>> getCommunityPosts() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/community');

      final List<dynamic> listCommunityPosts = response.data['data'];

      return listCommunityPosts
          .map((posts) => KomunitasModel.fromJson(posts))
          .toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list postingan komunitas';
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
  Future<List<CommentModel>> getCommunityComment({required String id}) async {
    try {
      Response<dynamic> response = await dio.get(
        '${TTexts.baseUrl}/community/comment?id=$id',
      );

      final Map<String, dynamic> dataJson = response.data['data'];

      final List<dynamic> listCommunityComment = dataJson['comments'] ?? [];

      return listCommunityComment
          .map((comments) => CommentModel.fromJson(comments))
          .toList();
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil list postingan komunitas';
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
