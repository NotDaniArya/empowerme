import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/main.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/auth/presentation/screens/register/register_screen.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';
import '../../../../../utils/shared_widgets/or_divider.dart';
import '../../../../../utils/shared_widgets/text_button.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _form = GlobalKey<FormState>();
  String _enteredEmail = '';
  String _enteredPass = '';
  bool _isPasswordVisible = false;

  void _submitLogin() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    ref
        .read(authNotifierProvider.notifier)
        .login(email: _enteredEmail, password: _enteredPass);
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
          'Login Gagal',
          'Email atau password anda mungkin saja salah atau belum terdaftar',
          ToastificationType.error,
        );
      }

      if (next is AsyncData && next.value != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const AuthGate()),
          (route) => false,
        );
      }
    });

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset('assets/icons/logo_app.png', width: 180),
                  Text(
                    'Bersama Lebih Kuat',
                    style: textTheme.headlineMedium!.copyWith(
                      color: TColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: TSizes.smallSpace),
                  Text(
                    'Login untuk Akses Komunitas Dan Dukungan Anda',
                    style: textTheme.titleMedium!.copyWith(
                      color: TColors.secondaryText,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                  Form(
                    key: _form,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TInputTextField(
                          icon: Icons.email_rounded,
                          labelText: 'Masukkan email anda',
                          inputType: TextInputType.emailAddress,
                          onSaved: (value) {
                            _enteredEmail = value!;
                          },
                          maxLength: 50,
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        TextFormField(
                          obscureText: !_isPasswordVisible,
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Masukkan password anda',
                            prefixIcon: const Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                              ),
                            ),
                            isDense: true,
                          ),
                          maxLength: 30,
                          autocorrect: false,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.trim().length < 8) {
                              return 'Panjang input minimal 8 karakter';
                            }

                            return null;
                          },
                          onSaved: (value) {
                            _enteredPass = value!;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwItems),
                  SizedBox(
                    width: 250,
                    child: MyButton(
                      text: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: TColors.primaryColor,
                              ),
                            )
                          : Text(
                              'Masuk',
                              style: textTheme.bodyLarge!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                      onPressed: isLoading ? null : _submitLogin,
                    ),
                  ),
                  const SizedBox(height: TSizes.mediumSpace),
                  const OrDivider(),
                  const MyTextButton(
                    text: Text('Belum Punya Akun?'),
                    buttonText: Text('Daftar sekarang'),
                    route: RegisterScreen(),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
