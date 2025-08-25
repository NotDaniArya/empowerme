import 'package:equatable/equatable.dart';

enum UserRole { pasien, konselor, pendamping, unknown }

class Auth extends Equatable {
  final String token;
  final UserRole role;
  final String id;

  const Auth({required this.token, required this.role, required this.id});

  @override
  // TODO: implement props
  List<Object?> get props => [token, role, id];
}
