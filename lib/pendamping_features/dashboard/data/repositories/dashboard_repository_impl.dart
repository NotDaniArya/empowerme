import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/pendamping_features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/dashboard/domain/entities/dashboard.dart';
import 'package:new_empowerme/pendamping_features/dashboard/domain/repositories/dashboard_repository.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDatasource remoteDatasource;

  const DashboardRepositoryImpl(this.remoteDatasource);

  @override
  Future<(Dashboard?, Failure?)> getDashboardData() async {
    try {
      final dashboardData = await remoteDatasource.getDashboardData();
      return (dashboardData, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
