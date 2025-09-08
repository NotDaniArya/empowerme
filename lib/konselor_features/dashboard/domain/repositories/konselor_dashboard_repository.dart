import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/konselor_features/dashboard/domain/entities/konselor_dashboard.dart';

abstract class KonselorDashboardRepository {
  Future<(KonselorDashboard?, Failure?)> getDashboardData();
}
