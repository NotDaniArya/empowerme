import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/panduan.dart';
import 'package:new_empowerme/user_features/edukasi/domain/repositories/panduan_repository.dart';

import '../datasources/panduan_remote_datasource.dart';

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

  @override
  Future<(void, Failure?)> postPanduan({
    required String title,
    required String description,
    required List<String> authors,
    required String publishedDate,
    required String infoLink,
  }) async {
    try {
      await remoteDataSource.postPanduan(
        title: title,
        description: description,
        authors: authors,
        publishedDate: publishedDate,
        infoLink: infoLink,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
