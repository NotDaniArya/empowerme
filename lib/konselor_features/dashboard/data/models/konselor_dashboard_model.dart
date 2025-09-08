import 'package:new_empowerme/konselor_features/dashboard/domain/entities/konselor_dashboard.dart';

class KonselorDashboardModel extends KonselorDashboard {
  const KonselorDashboardModel({required super.totalNewPatient});

  factory KonselorDashboardModel.fromJson(Map<String, dynamic> json) {
    return KonselorDashboardModel(totalNewPatient: json['data']);
  }
}
