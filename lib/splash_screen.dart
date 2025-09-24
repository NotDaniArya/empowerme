import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icons/logo_app.png', width: 200),
                Text(
                  'Peduli, Terhubung, Bangkit: Bersama untuk Masa Depan Lebih Baik',
                  textAlign: TextAlign.center,
                  style: textTheme.titleMedium!.copyWith(
                    color: TColors.secondaryText,
                  ),
                ),
                const SizedBox(height: TSizes.mediumSpace),
                const SizedBox(
                  width: 150,
                  child: SpinKitThreeInOut(
                    size: 30,
                    color: TColors.primaryColor,
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
