import 'package:equatable/equatable.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

enum TipeJadwal { terapi, ambilObat }

class JadwalPasien extends Equatable {
  final int idJadwal;
  final String date;
  final String time;
  final String location;
  final String meetWith;
  final String status;
  final Pasien pasien;

  const JadwalPasien({
    required this.idJadwal,
    required this.date,
    required this.time,
    required this.location,
    required this.meetWith,
    required this.status,
    required this.pasien,
  });

  JadwalPasien copyWith({
    int? idJadwal,
    String? date,
    String? time,
    String? location,
    String? meetWith,
    String? status,
    Pasien? pasien,
  }) {
    return JadwalPasien(
      idJadwal: idJadwal ?? this.idJadwal,
      date: date ?? this.date,
      time: time ?? this.time,
      location: location ?? this.location,
      meetWith: meetWith ?? this.meetWith,
      status: status ?? this.status,
      pasien: pasien ?? this.pasien,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    idJadwal,
    date,
    time,
    location,
    meetWith,
    status,
    pasien,
  ];
}
