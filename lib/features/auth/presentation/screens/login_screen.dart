import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/features/auth/presentation/screens/register_screen.dart';

import '../../../../navigation_menu.dart';
import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_widgets/button.dart';
import '../../../../utils/shared_widgets/input_text_field.dart';
import '../../../../utils/shared_widgets/or_divider.dart';
import '../../../../utils/shared_widgets/text_button.dart';

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
    //     .signIn(
    //       email: _enteredEmail.trim(),
    //       password: _enteredPass.trim(),
    //       onSucces: () {
    //         MyHelperFunction.toastNotification(
    //           'Berhasil login!. Selamat datang kembali.',
    //           true,
    //           context,
    //         );
    //         Navigator.pushReplacement(
    //           context,
    //           MaterialPageRoute(builder: (context) => const NavigationMenu()),
    //         );
    //       },
    //       onError: (error) =>
    //           MyHelperFunction.toastNotification(error, false, context),
    //     );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const NavigationMenu()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Container(
          margin: const EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Bersama Lebih Kuat',
                style: textTheme.headlineMedium!.copyWith(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TSizes.smallSpace),
              SizedBox(
                width: 255,
                child: Text(
                  'Login untuk Akses Komunitas Dan Dukungan Anda',
                  style: textTheme.titleMedium!.copyWith(
                    color: TColors.secondaryText,
                  ),
                ),
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
                    const SizedBox(height: TSizes.smallSpace),
                    TextButton(
                      onPressed: () {},
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        'Lupa password?',
                        textAlign: TextAlign.end,
                        style: textTheme.bodyMedium!.copyWith(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              SizedBox(
                width: 250,
                child: MyButton(
                  text: Text(
                    'Masuk',
                    style: textTheme.bodyLarge!.copyWith(color: Colors.white),
                  ),
                  onPressed: _submitLogin,
                ),
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
                label: const Text('Masuk dengan google'),
              ),
              const MyTextButton(
                text: Text('Belum Punya Akun?'),
                buttonText: Text('Daftar sekarang'),
                route: RegisterScreen(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
