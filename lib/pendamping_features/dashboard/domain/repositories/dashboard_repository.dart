import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/dashboard/domain/entities/dashboard.dart';

abstract class DashboardRepository {
  Future<(Dashboard?, Failure?)> getDashboardData();
}
