import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<(Profile?, Failure?)> getProfile({required String id});
}
