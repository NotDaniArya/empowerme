import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/data/datasources/jadwal_pasien_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/repositories/jadwal_pasien_repository.dart';

class JadwalPasienRepositoryImpl implements JadwalPasienRepository {
  final JadwalPasienRemoteDataSource remoteDataSource;

  const JadwalPasienRepositoryImpl(this.remoteDataSource);

  @override
  Future<(void, Failure?)> addJadwalTerapi({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
  }) async {
    try {
      await remoteDataSource.addJadwalTerapi(
        id: id,
        date: date,
        time: time,
        location: location,
        meetWith: meetWith,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> addJadwalAmbilObat({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required String typeDrug,
  }) async {
    try {
      await remoteDataSource.addJadwalAmbilObat(
        id: id,
        date: date,
        time: time,
        location: location,
        meetWith: meetWith,
        typeDrug: typeDrug,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalTerapiPasien({
    required String category,
  }) async {
    try {
      final jadwalPasienList = await remoteDataSource.getAllJadwalTerapiPasien(
        category: category,
      );
      return (jadwalPasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalAmbilObatPasien({
    required String category,
  }) async {
    try {
      final jadwalPasienList = await remoteDataSource
          .getAllJadwalAmbilObatPasien(category: category);
      return (jadwalPasienList, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> updateStatusTerapi({
    required String status,
    required int idJadwal,
  }) async {
    try {
      await remoteDataSource.updateStatusTerapi(
        status: status,
        idJadwal: idJadwal,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> updateStatusAmbilObat({
    required String status,
    required int idJadwal,
  }) async {
    try {
      await remoteDataSource.updateStatusAmbilObat(
        status: status,
        idJadwal: idJadwal,
      );
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
