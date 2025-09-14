import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:new_empowerme/app_root.dart';
import 'package:new_empowerme/konselor_navigation_menu.dart';
import 'package:new_empowerme/pendamping_navigation_menu.dart';
import 'package:new_empowerme/splash_screen.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/chat/data/models/chat_message_model.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';
import 'package:new_empowerme/user_features/onboarding/onboarding_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';

import 'navigation_menu.dart';

final theme = ThemeData().copyWith(
  colorScheme: ColorScheme.fromSeed(
    seedColor: TColors.primaryColor,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.dmSansTextTheme(),
);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();

  Hive.registerAdapter(MessageTypeAdapter());
  Hive.registerAdapter(ChatMessageModelAdapter());

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'EmpowerMe',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const AppRoot(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final splashState = ref.watch(splashDelayProvider);
    final authState = ref.watch(authNotifierProvider);

    return splashState.when(
      loading: () => const SplashScreen(),

      error: (err, stack) => Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(child: Text('Error: $err')),
      ),

      data: (_) {
        return authState.when(
          loading: () => const SplashScreen(),

          error: (error, stackTrace) => Scaffold(
            backgroundColor: TColors.backgroundColor,
            body: Center(child: Text('Terjadi kesalahan: $error')),
          ),

          data: (user) {
            if (user != null) {
              switch (user.role) {
                case UserRole.pasien:
                  print('User adalah pasien');
                  return const NavigationMenu();
                case UserRole.konselor:
                  print('User adalah konselor');
                  return const KonselorNavigationMenu();
                case UserRole.pendamping:
                  print('User adalah Pendamping');
                  return const PendampingNavigationMenu();
                default:
                  return const OnboardingScreen();
              }
            } else {
              return const OnboardingScreen();
            }
          },
        );
      },
    );
  }
}
