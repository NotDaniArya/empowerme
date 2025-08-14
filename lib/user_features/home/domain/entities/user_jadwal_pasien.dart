import 'package:equatable/equatable.dart';

enum TipeJadwal { terapi, ambilObat }

class UserJadwalPasien extends Equatable {
  final String idUser;
  final String email;
  final String name;
  final String picture;

  final int idJadwal;
  final String date;
  final String time;
  final String location;
  final String meetWith;
  final String status;

  const UserJadwalPasien({
    required this.idUser,
    required this.email,
    required this.name,
    required this.picture,
    required this.idJadwal,
    required this.date,
    required this.time,
    required this.location,
    required this.meetWith,
    required this.status,
  });

  UserJadwalPasien copyWith({
    String? idUser,
    String? email,
    String? name,
    String? picture,
    int? idJadwal,
    String? date,
    String? time,
    String? location,
    String? meetWith,
    String? status,
  }) {
    return UserJadwalPasien(
      idUser: idUser ?? this.idUser,
      email: email ?? this.email,
      name: name ?? this.name,
      picture: picture ?? this.picture,
      idJadwal: idJadwal ?? this.idJadwal,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      meetWith: meetWith ?? this.meetWith,
      status: status ?? this.status,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    idUser,
    email,
    name,
    picture,
    idJadwal,
    date,
    time,
    location,
    meetWith,
    status,
  ];
}
