import 'package:new_empowerme/core/failure.dart';

import '../../domain/entities/user_jadwal_pasien.dart';
import '../../domain/repositories/user_jadwal_pasien_repository.dart';
import '../datasources/user_jadwal_pasien_remote_datasource.dart';

class UserJadwalPasienRepositoryImpl implements UserJadwalPasienRepository {
  final UserJadwalPasienRemoteDataSource remoteDataSource;

  const UserJadwalPasienRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalTerapiPasien({
    required String id,
  }) async {
    try {
      final jadwalPasienList = await remoteDataSource.getAllJadwalTerapiPasien(
        id: id,
      );
      return (jadwalPasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalAmbilObatPasien({
    required String id,
  }) async {
    try {
      final jadwalPasienList = await remoteDataSource
          .getAllJadwalAmbilObatPasien(id: id);
      return (jadwalPasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
