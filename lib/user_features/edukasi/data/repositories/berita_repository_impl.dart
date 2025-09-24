import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/berita.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/berita_repository.dart';

import '../datasources/berita_remote_datasource.dart';

class BeritaRepositoryImpl implements BeritaRepository {
  final BeritaRemoteDataSource remoteDataSource;

  const BeritaRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Berita>?, Failure?)> getBeritaList() async {
    try {
      final beritaList = await remoteDataSource.getBeritaList();
      return (beritaList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> postBerita({
    required String title,
    required String author,
    required String description,
    required String publishedDate,
    required String url,
  }) async {
    try {
      await remoteDataSource.postBerita(
        title: title,
        author: author,
        description: description,
        publishedDate: publishedDate,
        url: url,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
