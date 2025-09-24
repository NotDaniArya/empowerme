import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/profile/presentation/providers/profile_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
import 'package:toastification/toastification.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ChangePasswordScreen> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _oldPasswordVisible = false;
  bool _newPasswordVisible = false;
  bool _confirmPasswordVisible = false;

  @override
  void dispose() {
    _oldPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitChangePassword() {
    if (!_formKey.currentState!.validate()) {
      return; // Jika validasi gagal, hentikan proses
    }

    // Panggil provider untuk update password
    ref
        .read(profileUpdaterProvider.notifier)
        .updatePassword(
          passwordOld: _oldPasswordController.text,
          passwordNew: _newPasswordController.text,
          passwordConfirm: _confirmPasswordController.text,
          onSuccess: () {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Password Anda berhasil diperbarui.',
              ToastificationType.success,
            );
            Navigator.of(context).pop();
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              error,
              ToastificationType.error,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileUpdaterProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Ganti Password',
          style: textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Keamanan Akun Anda',
                  style: textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                Text(
                  'Untuk melindungi akun Anda, pastikan password baru Anda kuat dan tidak mudah ditebak.',
                  style: textTheme.bodyMedium,
                ),
                const SizedBox(height: TSizes.spaceBtwSections * 1.5),

                // --- Input Password Lama ---
                TextFormField(
                  controller: _oldPasswordController,
                  obscureText: !_oldPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Lama',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _oldPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _oldPasswordVisible = !_oldPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password lama tidak boleh kosong';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // --- Input Password Baru ---
                TextFormField(
                  controller: _newPasswordController,
                  obscureText: !_newPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password Baru',
                    prefixIcon: const Icon(Icons.lock_clock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _newPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () => _newPasswordVisible = !_newPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Password baru tidak boleh kosong';
                    }
                    if (value.length < 8) {
                      return 'Password minimal harus 8 karakter';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                // --- Input Konfirmasi Password Baru ---
                TextFormField(
                  controller: _confirmPasswordController,
                  obscureText: !_confirmPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Konfirmasi Password Baru',
                    prefixIcon: const Icon(Icons.lock_person_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _confirmPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: () => setState(
                        () =>
                            _confirmPasswordVisible = !_confirmPasswordVisible,
                      ),
                    ),
                  ),
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Password konfirmasi tidak cocok';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwSections * 2),

                // --- Tombol Simpan ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _submitChangePassword,
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.5,
                            ),
                          )
                        : const Text('Simpan Perubahan'),
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
