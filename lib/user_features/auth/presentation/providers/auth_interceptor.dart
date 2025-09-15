import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';

class AuthInterceptor extends Interceptor {
  final Ref _ref;

  AuthInterceptor(this._ref);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final authDataSource = _ref.read(authLocalDataSourceProvider);
    final token = await authDataSource.getToken();

    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      print('Token kedaluwarsa atau tidak valid. Memulai proses logout...');

      _ref.read(authNotifierProvider.notifier).logout();
    }

    super.onError(err, handler);
  }
}
