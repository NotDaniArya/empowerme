import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:new_empowerme/user_features/profile/domain/entities/profile.dart';
import 'package:new_empowerme/user_features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  const ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<(Profile?, Failure?)> getProfile({required String id}) async {
    try {
      final profile = await remoteDataSource.getProfile(id: id);
      return (profile, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
