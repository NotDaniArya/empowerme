import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:new_empowerme/utils/shared_widgets/text_button.dart';
import 'package:pinput/pinput.dart';

import '../../../../../utils/constant/sizes.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    // --- konfigurasi Tampilan untuk Pinput ---
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: TColors.primaryColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: TColors.primaryColor.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(12),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: TColors.primaryColor),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );
    // --- Akhir Konfigurasi Tampilan ---

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(automaticallyImplyLeading: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Column(
            children: [
              /// Title & subtitle
              Text(
                'Masukkan kode OTP',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Text(
                'Kode verifikasi telah dikirim ke:',
                style: Theme.of(context).textTheme.labelMedium,
                textAlign: TextAlign.center,
              ),
              Text(
                'testing@gmail.com',
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 2),

              /// Input OTP di sini
              Pinput(
                length: 6, // Jumlah digit OTP
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                // showCursor: true,
                onCompleted: (pin) => print('Pin yang dimasukkan: $pin'),
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 2),

              /// buttons
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  text: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: () {
                    print('Tombol lanjutkan di tekan');
                  },
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              const MyTextButton(
                text: Text('Belum Mendapatkan Kode?'),
                buttonText: Text('Kirim Ulang Kode'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
