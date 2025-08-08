import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/pasien.dart';

class PasienModel extends Pasien {
  const PasienModel({
    required super.id,
    required super.email,
    required super.name,
    required super.picture,
  });

  factory PasienModel.fromJson(Map<String, dynamic> json) {
    return PasienModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
      picture: json['picture'],
    );
  }
}
