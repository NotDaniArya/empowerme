import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/auth/presentation/screens/register/verify_email.dart';

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
  String _enteredFullName = '';
  String _enteredEmail = '';
  String _enteredPass = '';
  String _enteredConfrimPass = '';
  bool _isPasswordVisible = false;

  void _submitSignUp() {
    // final isValid = _form.currentState!.validate();
    //
    // if (!isValid) {
    //   return;
    // }
    //
    // _form.currentState!.save();
    //
    // ref
    //     .read(authViewModelProvider.notifier)
    //     .signUp(
    //       email: _enteredEmail.trim(),
    //       password: _enteredPass.trim(),
    //       fullName: _enteredFullName.trim(),
    //       phoneNumber: _enteredPhoneNumber.trim(),
    //       onSuccess: () {
    //         MyHelperFunction.toastNotification(
    //           'Berhasil mendaftar. Silahkan login!',
    //           true,
    //           context,
    //         );
    //       },
    //       onError: (error) =>
    //           MyHelperFunction.toastNotification(error, false, context),
    //     );
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

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
                            value.trim().length < 4) {
                          return 'Panjang input minimal 4 karakter';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredPass = value!;
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
                        if (value == null ||
                            value.isEmpty ||
                            value.trim().length < 4 ||
                            value.trim() != _enteredPass) {
                          return 'Password anda tidak sama';
                        }

                        return null;
                      },
                      onSaved: (value) {
                        _enteredConfrimPass = value!;
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    MyButton(
                      text: Text(
                        'Daftar',
                        style: textTheme.bodyMedium!.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      onPressed: _submitSignUp,
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
