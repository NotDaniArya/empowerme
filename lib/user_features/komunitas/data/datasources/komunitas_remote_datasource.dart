import 'package:dio/dio.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/comment_model.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/komunitas_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class KomunitasRemoteDataSource {
  Future<List<KomunitasModel>> getCommunityPosts();

  Future<List<CommentModel>> getCommunityComment({required String id});

  Future<void> postCommunity({required String content, required String title});

  Future<void> addComment({required String id, required String comment});

  Future<void> addReplyComment({required String id, required String comment});
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

  @override
  Future<void> postCommunity({
    required String content,
    required String title,
  }) async {
    try {
      final now = DateTime.now();
      final formattedCreatedAt = now.toIso8601String().split('.').first;

      await dio.post(
        '${TTexts.baseUrl}/community',
        data: {
          "content": content,
          "title": title,
          "createAt": formattedCreatedAt,
        },
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal memposting komunitas';
      if (e.response != null) {
        errorMessage =
            'Gagal mengirim data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> addComment({required String id, required String comment}) async {
    try {
      await dio.post(
        '${TTexts.baseUrl}/comment?id=$id',
        data: {"comment": comment},
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengirim komentar postingan';
      if (e.response != null) {
        errorMessage =
            'Gagal mengirim data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }

  @override
  Future<void> addReplyComment({
    required String id,
    required String comment,
  }) async {
    try {
      await dio.post(
        '${TTexts.baseUrl}/replay?id=$id',
        data: {"comment": comment},
      );
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengirim komentar postingan';
      if (e.response != null) {
        errorMessage =
            'Gagal mengirim data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
