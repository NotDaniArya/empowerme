import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/data/datasources/makanan_remote_datasource.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/makanan.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/makanan_repository.dart';

class MakananRepositoryImpl implements MakananRepository {
  final MakananRemoteDataSource remoteDataSource;

  const MakananRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Makanan>?, Failure?)> getMakanan() async {
    try {
      final makananList = await remoteDataSource.getMakanan();
      return (makananList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
