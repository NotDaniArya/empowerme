import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';

import '../../domain/repositories/obat_repository.dart';
import '../datasources/obat_remote_datasource.dart';

class ObatRepositoryImpl implements ObatRepository {
  final ObatRemoteDataSource remoteDataSource;

  const ObatRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Obat>?, Failure?)> getObat() async {
    try {
      final obatList = await remoteDataSource.getObat();
      return (obatList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> postObat({
    required String title,
    required String source,
    required String date,
    required String snippet,
    required String link,
  }) async {
    try {
      await remoteDataSource.postObat(
        title: title,
        source: source,
        date: date,
        snippet: snippet,
        link: link,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
