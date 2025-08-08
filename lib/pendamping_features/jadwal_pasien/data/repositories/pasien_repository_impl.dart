import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/datasources/pasien_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/repositories/pasien_repository.dart';

class PasienRepositoryImpl implements PasienRepository {
  final PasienRemoteDataSource remoteDataSource;

  const PasienRepositoryImpl(this.remoteDataSource);

  @override
  Future<(List<Pasien>?, Failure?)> getAllPasien() async {
    try {
      final pasienList = await remoteDataSource.getAllPasien();
      return (pasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
