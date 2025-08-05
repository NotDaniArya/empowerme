import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/auth/presentation/screens/login/login_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:pinput/pinput.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/constant/sizes.dart';
import '../../providers/auth_provider.dart';

class VerifyEmailScreen extends ConsumerStatefulWidget {
  const VerifyEmailScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends ConsumerState<VerifyEmailScreen> {
  String _enteredOtp = '';

  void _submitOtp() {
    if (_enteredOtp.length < 6) {
      toastification.dismissAll();
      toastification.show(
        context: context,
        type: ToastificationType.warning,
        title: const Text('OTP Tidak Lengkap'),
        description: const Text('Mohon masukkan 6 digit kode OTP.'),
        autoCloseDuration: const Duration(seconds: 4),
      );
      return;
    }

    ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email: widget.email, otp: _enteredOtp);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    ref.listen(authNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          alignment: Alignment.bottomRight,
          title: Text(
            'Verifikasi Gagal!',
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          description: Text(
            'Kode OTP yang anda masukkan tidak sesuai',
            style: textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
          ),
          autoCloseDuration: const Duration(seconds: 4),
          icon: const Icon(Icons.error),
        );
      }

      toastification.dismissAll();
      if (next is AsyncData) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          alignment: Alignment.bottomRight,
          title: const Text('Verifikasi Berhasil!'),
          description: const Text(
            'Akun Anda telah diaktifkan. Silahkan melakukan login',
          ),
          autoCloseDuration: const Duration(seconds: 4),
          icon: const Icon(Icons.check_circle),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      }
    });

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

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Column(
            children: [
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
                widget.email,
                style: Theme.of(context).textTheme.labelLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 2),

              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                onCompleted: (pin) {
                  _enteredOtp = pin;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections * 2),

              SizedBox(
                width: double.infinity,
                child: MyButton(
                  text: const Text(
                    'Verifikasi OTP',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onPressed: isLoading ? null : _submitOtp,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Belum mendapatkan kode?'),
                  const SizedBox(width: 5),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: Size.zero,
                    ),
                    child: const Text('Kirim Ulang kode'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
