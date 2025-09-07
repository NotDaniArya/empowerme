import 'dart:io';

import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/profile/domain/entities/profile.dart';

abstract class ProfileRepository {
  Future<(Profile?, Failure?)> getProfile({required String id});

  Future<(void, Failure?)> updateProfilePicture({required File imageFile});

  Future<(void, Failure?)> updateName({required String name});

  Future<(void, Failure?)> updatePassword({
    required String passwordNew,
    required String passwordConfirm,
    required String passwordOld,
  });
}
