import 'package:new_empowerme/pendamping_features/daftar_pasien/data/model/pasien_model.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';

class JadwalPasienModel extends JadwalPasien {
  const JadwalPasienModel({
    required super.idJadwal,
    required super.date,
    required super.time,
    required super.location,
    required super.meetWith,
    required super.status,
    required super.pasien,
  });

  factory JadwalPasienModel.fromJson(Map<String, dynamic> json) {
    if (json['patient'] == null) {
      throw const FormatException(
        "Data pasien tidak ditemukan dalam respons JSON.",
      );
    }

    return JadwalPasienModel(
      idJadwal: json['id'],
      date: json['date'],
      time: json['time'],
      location: json['location'],
      meetWith: json['meetWith'],
      status: json['status'],
      pasien: PasienModel.fromJson(json['patient']),
    );
  }
}
