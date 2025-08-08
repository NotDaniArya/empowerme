import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/pasien.dart';

abstract class PasienRepository {
  Future<(List<Pasien>?, Failure?)> getAllPasien();
}
