import 'package:new_empowerme/core/failure.dart';

import '../entities/user_jadwal_pasien.dart';

abstract class UserJadwalPasienRepository {
  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalTerapiPasien();

  Future<(List<UserJadwalPasien>?, Failure?)> getAllJadwalAmbilObatPasien();
}
