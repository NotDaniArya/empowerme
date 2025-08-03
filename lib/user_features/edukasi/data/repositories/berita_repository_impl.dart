import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/data/datasource/berita_remote_datasource.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/berita.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/berita_repository.dart';

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
}
