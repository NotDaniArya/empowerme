import 'package:equatable/equatable.dart';

class KonselorDashboard extends Equatable {
  final int totalNewPatient;

  const KonselorDashboard({required this.totalNewPatient});

  @override
  // TODO: implement props
  List<Object?> get props => [totalNewPatient];
}
