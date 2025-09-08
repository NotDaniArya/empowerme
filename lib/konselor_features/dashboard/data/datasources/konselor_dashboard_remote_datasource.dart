import 'package:dio/dio.dart';
import 'package:new_empowerme/konselor_features/dashboard/data/models/konselor_dashboard_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class KonselorDashboardRemoteDataSource {
  Future<KonselorDashboardModel> getDashboardData();
}

class KonselorDashboardRemoteDataSourceImpl
    implements KonselorDashboardRemoteDataSource {
  final Dio dio;

  const KonselorDashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<KonselorDashboardModel> getDashboardData() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/dashboard/counselor');

      final dynamic dashboardData = response.data;

      return KonselorDashboardModel.fromJson(dashboardData);
    } on DioException catch (e) {
      String errorMessage = 'Gagal mengambil data dashboard';
      if (e.response != null) {
        errorMessage =
            'Gagal mengambil data: ${e.response?.statusMessage}. Status: ${e.response?.statusCode}';
      } else {
        errorMessage = 'Gagal terhubung ke server: ${e.message}';
      }
      throw Failure(errorMessage, statusCode: e.response?.statusCode);
    }
  }
}
