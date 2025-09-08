import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/konselor_features/dashboard/data/datasources/konselor_dashboard_remote_datasource.dart';
import 'package:new_empowerme/konselor_features/dashboard/domain/entities/konselor_dashboard.dart';
import 'package:new_empowerme/konselor_features/dashboard/domain/repositories/konselor_dashboard_repository.dart';

class KonselorDashboardRepositoryImpl implements KonselorDashboardRepository {
  final KonselorDashboardRemoteDataSource remoteDataSource;

  const KonselorDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<(KonselorDashboard?, Failure?)> getDashboardData() async {
    try {
      final dashboardData = await remoteDataSource.getDashboardData();
      return (dashboardData, null);
    } on Failure catch (f) {
      return (null, f);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }
}
