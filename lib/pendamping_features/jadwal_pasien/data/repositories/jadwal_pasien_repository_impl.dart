import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/datasources/jadwal_pasien_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/repositories/jadwal_pasien_repository.dart';

class JadwalPasienRepositoryImpl implements JadwalPasienRepository {
  final JadwalPasienRemoteDataSource remoteDataSource;

  const JadwalPasienRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalPasien({
    required String category,
  }) async {
    try {
      final jadwalPasienList = await remoteDataSource.getAllJadwalPasien(
        category: category,
      );
      return (jadwalPasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
