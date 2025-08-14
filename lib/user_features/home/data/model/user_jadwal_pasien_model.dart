import '../../domain/entities/user_jadwal_pasien.dart';

class UserJadwalPasienModel extends UserJadwalPasien {
  const UserJadwalPasienModel({
    required super.idUser,
    required super.email,
    required super.name,
    required super.picture,
    required super.idJadwal,
    required super.date,
    required super.time,
    required super.location,
    required super.meetWith,

    required super.status,
  });

  static List<UserJadwalPasienModel> fromJsonList(Map<String, dynamic> json) {
    final List<dynamic> historiesJson = json['histories'] ?? [];

    return historiesJson.map((historyJson) {
      return UserJadwalPasienModel(
        idUser: json['id'],
        email: json['email'],
        name: json['name'],
        picture: json['picture'],

        idJadwal: historyJson['id'],
        date: historyJson['date'],
        time: historyJson['time'],
        location: historyJson['location'],
        meetWith: historyJson['meetWith'],
        status: historyJson['status'],
      );
    }).toList();
  }
}
