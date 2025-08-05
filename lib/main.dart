import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:new_empowerme/navigation_menu.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/onboarding/onboarding_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

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
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Wedding Organizer app',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const AuthGate(),
    );
  }
}

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);

    return authState.when(
      data: (user) {
        if (user != null) {
          print(
            'AUTHGATE: User ditemukan! Role: ${user.role}. Menampilkan NavigationMenu...',
          );
          switch (user.role) {
            case UserRole.pasien:
              print('Navigasi ke Beranda Pasien');
              return const NavigationMenu();

            case UserRole.konselor:
              print('Navigasi ke Beranda Konselor');
              return const Scaffold(
                body: Center(child: Text('Beranda Konselor')),
              );

            case UserRole.pendamping:
              print('Navigasi ke Beranda Pendamping');
              return const Scaffold(
                body: Center(child: Text('Beranda Pendamping')),
              );

            default:
              print('Role tidak dikenali, arahkan ke onboarding');
              return const OnboardingScreen();
          }
        } else {
          print('AUTHGATE: User null. Menampilkan Onboarding/Login...');
          return const OnboardingScreen();
        }
      },
      error: (error, stackTrace) =>
          Scaffold(body: Center(child: Text('Terjadi kesalahan: $error'))),
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}
