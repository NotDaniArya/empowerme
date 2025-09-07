import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:new_empowerme/pendamping_features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:new_empowerme/pendamping_features/dashboard/domain/entities/dashboard.dart';
import 'package:new_empowerme/pendamping_features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

class DashboardState {
  final Dashboard? dashboard;
  final bool isLoading;
  final String? error;

  DashboardState({this.dashboard, this.isLoading = false, this.error});

  DashboardState copyWith({
    Dashboard? dashboard,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return DashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final dashboardRemoteDataSourceProvider = Provider<DashboardRemoteDatasource>(
  (ref) => DashboardRemoteDataSourceImpl(ref.watch(dioProvider)),
);

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) =>
      DashboardRepositoryImpl(ref.watch(dashboardRemoteDataSourceProvider)),
);

class DashboardViewModel extends Notifier<DashboardState> {
  @override
  DashboardState build() {
    Future.microtask(fetchDashboard);
    return DashboardState(isLoading: true);
  }

  DashboardRepository get _repository => ref.read(dashboardRepositoryProvider);

  Future<void> fetchDashboard() async {
    state = state.copyWith(isLoading: true, clearError: true);
    final (dashboard, failure) = await _repository.getDashboardData();

    if (failure != null) {
      state = state.copyWith(isLoading: false, error: failure.message);
    } else {
      state = state.copyWith(dashboard: dashboard, isLoading: false);
    }
  }
}

final dashboardViewModel = NotifierProvider<DashboardViewModel, DashboardState>(
  () => DashboardViewModel(),
);
