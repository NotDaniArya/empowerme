import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/komunitas/data/datasources/komunitas_remote_datasource.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';
import 'package:new_empowerme/user_features/komunitas/domain/repositories/komunitas_repository.dart';

class KomunitasRepositoryImpl implements KomunitasRepository {
  final KomunitasRemoteDataSource remoteDataSource;

  const KomunitasRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Komunitas>?, Failure?)> getCommunityPosts() async {
    try {
      final postinganList = await remoteDataSource.getCommunityPosts();
      return (postinganList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<Comment>?, Failure?)> getCommunityComment({
    required String id,
  }) async {
    try {
      final commentList = await remoteDataSource.getCommunityComment(id: id);
      return (commentList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
