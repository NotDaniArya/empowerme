import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/auth/presentation/screens/register/verify_email.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';
import '../../../../../utils/shared_widgets/input_text_field.dart';
import '../../../../../utils/shared_widgets/or_divider.dart';
import '../../../../../utils/shared_widgets/text_button.dart';
import '../login/login_screen.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _enteredFullName = '';
  String _enteredEmail = '';
  bool _isPasswordVisible = false;

  void _submitSignUp() {
    final isValid = _form.currentState!.validate();

    if (!isValid) {
      return;
    }

    _form.currentState!.save();

    ref
        .read(authNotifierProvider.notifier)
        .register(
          name: _enteredFullName,
          email: _enteredEmail,
          password: _passwordController.text,
          passwordConfirm: _passwordController.text,
        );
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);
    final isLoading = authState is AsyncLoading;

    ref.listen(authNotifierProvider, (previous, next) {
      toastification.dismissAll();
      if (next is AsyncError) {
        toastification.show(
          context: context,
          type: ToastificationType.error,
          style: ToastificationStyle.flatColored,
          title: Text(
            'Register Gagal',
            style: textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          description: Text(
            'Email yang anda gunakan mungkin saja sudah terdaftar atau terjadi kesalahan saat melakukan pendaftaran',
            style: textTheme.bodySmall,
          ),
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          icon: const Icon(Icons.error),
        );
      }

      if (next is AsyncData) {
        toastification.show(
          context: context,
          type: ToastificationType.success,
          style: ToastificationStyle.flatColored,
          title: const Text('Kode OTP Terkirim!'),
          description: const Text(
            'Masukkan Kode OTP yang dikirim Ke Email anda',
          ),
          alignment: Alignment.bottomRight,
          autoCloseDuration: const Duration(seconds: 4),
          icon: const Icon(Icons.check_circle),
        );

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VerifyEmailScreen(email: _enteredEmail),
          ),
        );
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Form(
              key: _form,
              child: Container(
                margin: const EdgeInsets.only(bottom: 45),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    Text(
                      'Mulai Perjalanan Baru Anda',
                      style: textTheme.headlineSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: TColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      labelText: 'Masukkan Nama Anda',
                      maxLength: 20,
                      icon: Icons.person,
                      minLength: 4,
                      inputType: TextInputType.name,
                      onSaved: (value) {
                        _enteredFullName = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TInputTextField(
                      icon: Icons.email_rounded,
                      labelText: 'Masukkan email anda',
                      inputType: TextInputType.emailAddress,
                      onSaved: (value) {
                        _enteredEmail = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Masukkan password anda',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.lock),
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
                      maxLength: 15,
                      autocorrect: false,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 8) {
                          return 'Panjang input minimal 8 karakter';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    TextFormField(
                      obscureText: !_isPasswordVisible,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Kofirmasi password anda',
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
                      maxLength: 15,
                      autocorrect: false,
                      validator: (value) {
                        if (value != _passwordController.text) {
                          return 'Password anda tidak sama';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    MyButton(
                      text: isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                color: TColors.primaryColor,
                              ),
                            )
                          : Text(
                              'Daftar',
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                              ),
                            ),
                      onPressed: isLoading ? null : _submitSignUp,
                    ),
                    const SizedBox(height: TSizes.mediumSpace),
                    const OrDivider(),
                    const SizedBox(height: TSizes.mediumSpace),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: TColors.secondaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadiusGeometry.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      icon: const FaIcon(
                        FontAwesomeIcons.google,
                        color: Colors.redAccent,
                      ),
                      label: const Text('Daftar dengan google'),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    const MyTextButton(
                      text: Text('Sudah Punya Akun?'),
                      buttonText: Text('Masuk sekarang'),
                      route: LoginScreen(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
