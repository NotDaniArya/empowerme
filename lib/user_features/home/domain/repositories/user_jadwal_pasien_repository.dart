import 'package:new_empowerme/core/failure.dart';

import '../entities/user_jadwal_pasien.dart';

abstract class UserJadwalPasienRepository {
  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalTerapiPasien({
    required String id,
  });

  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalAmbilObatPasien({
    required String id,
  });
}
