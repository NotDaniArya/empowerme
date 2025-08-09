import 'package:equatable/equatable.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

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
