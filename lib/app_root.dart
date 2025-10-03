import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_providers/connectivity_status_provider.dart';

import 'main.dart';

class AppRoot extends ConsumerWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final connectivityStatus = ref.watch(connectivityNotifierProvider);

    switch (connectivityStatus) {
      case ConnectivityStatus.online:
        return const AuthGate();
      case ConnectivityStatus.offline:
        return const OfflineScreen();
      case ConnectivityStatus.checking:
      default:
        return const Scaffold(
          body: Center(
            child: SpinKitThreeInOut(size: 30, color: TColors.primaryColor),
          ),
        );
    }
  }
}

class OfflineScreen extends ConsumerWidget {
  const OfflineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/animations/no_connection.json',
                width: 230,
                height: 230,
              ),
              Text(
                'Koneksi Terputus',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              // const SizedBox(height: 12),
              const Text(
                'Anda tidak terhubung ke internet. Mohon periksa koneksi Anda dan coba lagi.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton.icon(
                onPressed: () => ref
                    .read(connectivityNotifierProvider.notifier)
                    .recheckConnectivity(),
                icon: const Icon(Icons.refresh, color: Colors.white),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
