import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String email;
  final String name;
  final String picture;
  final String? status;
  final String? drug;

  const Profile({
    required this.email,
    required this.name,
    required this.picture,
    this.status,
    this.drug,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [email, name, picture, status, drug];
}
