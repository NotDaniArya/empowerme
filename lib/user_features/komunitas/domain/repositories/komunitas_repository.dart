import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';

abstract class KomunitasRepository {
  Future<(List<Komunitas>?, Failure?)> getCommunityPosts();

  Future<(List<Comment>?, Failure?)> getCommunityComment({required String id});

  Future<(void, Failure?)> postCommunityPosts({
    required String content,
    required String title,
  });

  Future<(void, Failure?)> addComment({
    required String id,
    required String comment,
  });
}
