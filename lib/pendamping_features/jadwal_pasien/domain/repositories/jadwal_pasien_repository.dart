import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';

abstract class JadwalPasienRepository {
  Future<(void, Failure?)> addJadwalTerapi({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
  });

  Future<(void, Failure?)> addJadwalAmbilObat({
    required String id,
    required String date,
    required String time,
    required String location,
    required String meetWith,
    required String typeDrug,
  });

  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalTerapiPasien({
    required String category,
  });

  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalAmbilObatPasien({
    required String category,
  });

  Future<(void, Failure?)> updateStatusTerapi({
    required String status,
    required int idJadwal,
  });

  Future<(void, Failure?)> updateStatusAmbilObat({
    required String status,
    required int idJadwal,
  });
}
