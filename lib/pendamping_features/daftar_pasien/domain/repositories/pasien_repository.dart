import 'package:new_empowerme/core/failure.dart';

import '../entities/pasien.dart';

abstract class PasienRepository {
  Future<(List<Pasien>?, Failure?)> getAllPasien();
}
