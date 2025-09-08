import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/konselor_features/dashboard/data/datasources/konselor_dashboard_remote_datasource.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

import '../../data/repositories/konselor_dashboard_repository_impl.dart';
import '../../domain/entities/konselor_dashboard.dart';
import '../../domain/repositories/konselor_dashboard_repository.dart';

class KonselorDashboardState {
  final KonselorDashboard? dashboard;
  final bool isLoading;
  final String? error;

  KonselorDashboardState({this.dashboard, this.isLoading = false, this.error});

  KonselorDashboardState copyWith({
    KonselorDashboard? dashboard,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return KonselorDashboardState(
      dashboard: dashboard ?? this.dashboard,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

final konselorDashboardRemoteDataSourceProvider =
    Provider<KonselorDashboardRemoteDataSource>(
      (ref) => KonselorDashboardRemoteDataSourceImpl(ref.watch(dioProvider)),
    );

final konselorDashboardRepositoryProvider =
    Provider<KonselorDashboardRepository>(
      (ref) => KonselorDashboardRepositoryImpl(
        ref.watch(konselorDashboardRemoteDataSourceProvider),
      ),
    );

class KonselorDashboardViewModel extends Notifier<KonselorDashboardState> {
  @override
  KonselorDashboardState build() {
    Future.microtask(fetchDashboard);
    return KonselorDashboardState(isLoading: true);
  }

  KonselorDashboardRepository get _repository =>
      ref.read(konselorDashboardRepositoryProvider);

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

final konselorDashboardViewModel =
    NotifierProvider<KonselorDashboardViewModel, KonselorDashboardState>(
      () => KonselorDashboardViewModel(),
    );
