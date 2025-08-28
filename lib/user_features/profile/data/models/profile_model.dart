import 'package:new_empowerme/user_features/profile/domain/entities/profile.dart';

class ProfileModel extends Profile {
  const ProfileModel({
    required super.email,
    required super.name,
    required super.picture,
    super.status,
    super.drug,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      email: json['email'] ?? 'Email tidak diketahui',
      name: json['name'] ?? 'Nama user tidak diketahui',
      picture: json['picture'] ?? '',
      status: json['status'],
      drug: json['drug'],
    );
  }
}
