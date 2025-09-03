import 'package:new_empowerme/pendamping_features/dashboard/domain/entities/dashboard.dart';

class DashboardModel extends Dashboard {
  const DashboardModel({
    required super.totalPatientCount,
    required super.scheduledTherapyCount,
    required super.scheduledMedicationCount,
    required super.missedTherapyCount,
    required super.missedMedicationCount,
  });

  factory DashboardModel.fromJson(Map<String, dynamic> json) {
    return DashboardModel(
      totalPatientCount: json['numberOfPatients'],
      scheduledTherapyCount: json['numberOfPatientsNextTherapy'],
      scheduledMedicationCount: json['numberOfPatientsNextMedication'],
      missedTherapyCount: json['numberOfPatientsUndergoingMissedTherapy'],
      missedMedicationCount: json['numberOfPatientsMissedTakingMedication'],
    );
  }
}
