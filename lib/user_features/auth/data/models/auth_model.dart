import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';

class AuthModel extends Auth {
  const AuthModel({required super.token, required super.role});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;

    return AuthModel(token: data['token'], role: _parseRole(data['role']));
  }

  // function untuk mengubah string role menjadi Enum
  static UserRole _parseRole(String role) {
    switch (role.toLowerCase()) {
      case 'pasien':
        return UserRole.pasien;
      case 'konselor':
        return UserRole.konselor;
      case 'pendamping':
        return UserRole.pendamping;
      default:
        return UserRole.unknown;
    }
  }
}
