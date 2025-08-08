import 'package:equatable/equatable.dart';

class Pasien extends Equatable {
  final String id;
  final String email;
  final String name;
  final String picture;

  const Pasien({
    required this.id,
    required this.email,
    required this.name,
    required this.picture,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, email, name, picture];
}
