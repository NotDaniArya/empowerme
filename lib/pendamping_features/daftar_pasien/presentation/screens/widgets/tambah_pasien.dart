import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/providers/pasien_provider.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/helper_functions/helper.dart';
import '../../../../../utils/shared_widgets/button.dart';

class TambahPasien extends ConsumerStatefulWidget {
  const TambahPasien({super.key});

  @override
  ConsumerState<TambahPasien> createState() => _TambahPasienState();
}

class _TambahPasienState extends ConsumerState<TambahPasien> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _submitAddPasien() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

    ref
        .read(pasienUpdaterProvider.notifier)
        .addPasienBaru(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          onSuccess: () {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Pasien berhasil ditambah.',
              ToastificationType.success,
            );
            Navigator.of(context).pop();
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              'Pasien gagal ditambah',
              ToastificationType.error,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(pasienUpdaterProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(TSizes.scaffoldPadding).copyWith(
        bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.mediumSpace,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _nameController,
              keyboardType: TextInputType.name,
              decoration: const InputDecoration(
                labelText: 'Nama Pasien',
                hintText: 'Masukkan nama pasien...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null ||
                    value.trim().isEmpty ||
                    value.trim().length < 4) {
                  return 'Nama tidak boleh kosong dan panjang minimal adalah 4 karakter';
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email Pasien',
                hintText: 'Masukkan email pasien...',
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || value.trim().length < 8) {
                  return 'Panjang input minimal 8 karakter';
                }

                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            SizedBox(
              width: double.infinity,
              child: MyButton(
                onPressed: isLoading ? null : _submitAddPasien,
                text: isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Tambah Pasien',
                        style: TextStyle(color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
