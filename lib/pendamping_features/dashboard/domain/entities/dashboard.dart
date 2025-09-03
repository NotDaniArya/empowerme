import 'package:equatable/equatable.dart';

class Dashboard extends Equatable {
  final int totalPatientCount;
  final int scheduledTherapyCount;
  final int scheduledMedicationCount;
  final int missedTherapyCount;
  final int missedMedicationCount;

  const Dashboard({
    required this.totalPatientCount,
    required this.scheduledTherapyCount,
    required this.scheduledMedicationCount,
    required this.missedTherapyCount,
    required this.missedMedicationCount,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    totalPatientCount,
    scheduledTherapyCount,
    scheduledMedicationCount,
    missedTherapyCount,
    missedMedicationCount,
  ];
}
