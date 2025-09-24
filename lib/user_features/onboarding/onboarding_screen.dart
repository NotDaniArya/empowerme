import 'package:flutter/material.dart';

import '../../utils/constant/colors.dart';
import '../../utils/constant/sizes.dart';
import '../../utils/shared_widgets/button.dart';
import '../../utils/shared_widgets/or_divider.dart';
import '../auth/presentation/screens/login/login_screen.dart';
import '../auth/presentation/screens/register/register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.spaceBtwSections),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/icons/logo_app.png', width: 200),
                Text(
                  'Peduli, Terhubung, Bangkit: Bersama untuk Masa Depan Lebih Baik',
                  textAlign: TextAlign.center,
                  style: textTheme.titleSmall!.copyWith(
                    color: TColors.secondaryText,
                  ),
                ),
                const SizedBox(height: TSizes.largeSpace),
                SizedBox(
                  width: 250,
                  child: MyButton(
                    text: Text(
                      'Masuk',
                      style: textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: TSizes.mediumSpace),
                const OrDivider(),
                const SizedBox(height: TSizes.mediumSpace),
                SizedBox(
                  width: 250,
                  child: MyButton(
                    text: Text(
                      'Daftar',
                      style: textTheme.titleMedium!.copyWith(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RegisterScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
