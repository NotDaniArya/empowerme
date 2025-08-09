import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final dioProvider = Provider<Dio>((ref) => Dio());

final splashDelayProvider = FutureProvider<void>((ref) async {
  await Future.delayed(const Duration(seconds: 7));
});
