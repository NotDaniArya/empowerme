import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';

abstract class JadwalPasienRepository {
  Future<(List<JadwalPasien>?, Failure?)> getAllJadwalPasien({
    required String category,
  });

  Future<(void, Failure?)> updateStatusTerapi({
    required String status,
    required int idJadwal,
  });
}
