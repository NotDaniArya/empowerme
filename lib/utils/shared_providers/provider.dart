import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user_features/auth/presentation/providers/auth_interceptor.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio();

  dio.interceptors.add(AuthInterceptor(ref));

  return dio;
});

final navigatorKey = GlobalKey<NavigatorState>();

final splashDelayProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 7));
});
