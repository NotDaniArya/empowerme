import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/auth/presentation/screens/login/login_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
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
  Timer? _timer;
  int _start = 60;
  bool _isResendButtonActive = true;
  bool _isResending = false;

  void _submitOtp() {
    if (_enteredOtp.length < 6) {
      MyHelperFunction.showToast(
        context,
        'OTP Tidak Lengkap',
        'Mohon masukkan 6 digit kode OTP.',
        ToastificationType.warning,
      );
      return;
    }

    ref
        .read(authNotifierProvider.notifier)
        .verifyOtp(email: widget.email, otp: _enteredOtp);
  }

  void startTimer() {
    setState(() {
      _isResendButtonActive = false;
      _start = 60;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          timer.cancel();
          _isResendButtonActive = true;
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  void _resendOtp() async {
    setState(() {
      _isResending = true;
    });
    try {
      await ref
          .read(authNotifierProvider.notifier)
          .requestOtp(email: widget.email);
      if (mounted) {
        MyHelperFunction.showToast(
          context,
          'Sukses',
          'Kode OTP baru telah dikirim ke email Anda.',
          ToastificationType.success,
        );
        startTimer();
      }
    } catch (error) {
      if (mounted) {
        MyHelperFunction.showToast(
          context,
          'Gagal',
          'Kode OTP gagal dikirim ulang',
          ToastificationType.error,
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isResending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    ref.listen(authNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        MyHelperFunction.showToast(
          context,
          'Verifikasi Gagal!',
          'Kode OTP yang anda masukkan tidak sesuai',
          ToastificationType.error,
        );
      }

      if (next is AsyncData) {
        MyHelperFunction.showToast(
          context,
          'Verifikasi Berhasil!',
          'Akun Anda telah diaktifkan. Silahkan melakukan login',
          ToastificationType.success,
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
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
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
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
              const Text('Belum mendapatkan kode?'),
              TextButton(
                onPressed: _isResendButtonActive && !_isResending
                    ? _resendOtp
                    : null,
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                ),
                child: _isResending
                    ? const CircularProgressIndicator()
                    : Text(
                        _isResendButtonActive
                            ? 'Kirim Ulang kode'
                            : 'Kirim ulang dalam ($_start)',
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
