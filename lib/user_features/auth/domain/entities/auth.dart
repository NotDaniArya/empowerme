import 'package:equatable/equatable.dart';

enum UserRole { pasien, konselor, pendamping, unknown }

class Auth extends Equatable {
  final String token;
  final UserRole role;

  const Auth({required this.token, required this.role});

  @override
  // TODO: implement props
  List<Object?> get props => [token, role];
}
