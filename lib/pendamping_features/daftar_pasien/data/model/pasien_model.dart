import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

class PasienModel extends Pasien {
  const PasienModel({
    required super.id,
    required super.email,
    required super.name,
    required super.picture,
    required super.status,
  });

  factory PasienModel.fromJson(Map<String, dynamic> json) {
    return PasienModel(
      id: json['id'] ?? 'id kosong',
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
      status: json['status'] ?? 'status tidak ada',
    );
  }
}
