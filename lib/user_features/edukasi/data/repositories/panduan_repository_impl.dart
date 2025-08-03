import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/data/datasource/panduan_remote_datasource.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/panduan.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/panduan_repository.dart';

class PanduanRepositoryImpl implements PanduanRepository {
  final PanduanRemoteDataSource remoteDataSource;

  const PanduanRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Panduan>?, Failure?)> getPanduanList() async {
    try {
      final panduanList = await remoteDataSource.getPanduanList();
      return (panduanList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
