import 'package:new_empowerme/core/failure.dart';

import '../entities/pasien.dart';

abstract class PasienRepository {
  Future<(List<Pasien>?, Failure?)> getAllPasien();

  Future<(void, Failure?)> updateStatus({required String id});

  Future<(void, Failure?)> addPasienBaru({
    required String name,
    required String email,
  });
}
