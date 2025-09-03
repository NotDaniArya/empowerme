import 'package:dio/dio.dart';
import 'package:new_empowerme/pendamping_features/dashboard/data/models/dashboard_model.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../../core/failure.dart';

abstract class DashboardRemoteDatasource {
  Future<DashboardModel> getDashboardData();
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDatasource {
  final Dio dio;

  const DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<DashboardModel> getDashboardData() async {
    try {
      final response = await dio.get('${TTexts.baseUrl}/dashboard');

      final dynamic dashboardData = response.data['data'];

      return DashboardModel.fromJson(dashboardData);
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
