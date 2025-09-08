import 'dart:async';

import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/repositories/pasien_repository.dart';

import '../datasources/pasien_remote_datasource.dart';

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

  @override
  Future<(void, Failure?)> updateStatus({required String id}) async {
    try {
      await remoteDataSource.updateStatus(id: id);
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(void, Failure?)> addPasienBaru({
    required String name,
    required String email,
  }) async {
    try {
      await remoteDataSource.addPasienBaru(name: name, email: email);
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
