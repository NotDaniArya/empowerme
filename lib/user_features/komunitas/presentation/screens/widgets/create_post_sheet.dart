// lib/user_features/komunitas/presentation/screens/widgets/create_post_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/helper_functions/helper.dart';

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submitPost() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    ref
        .read(komunitasUpdaterProvider.notifier)
        .postCommunity(
          content: _contentController.text,
          onSuccess: () {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Postingan berhasil diunggah.',
              ToastificationType.success,
            );
            Navigator.of(context).pop();
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              'Postingan gagal diunggah',
              ToastificationType.error,
            );
          },
        );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding).copyWith(
          bottom: MediaQuery.of(context).viewInsets.bottom + TSizes.mediumSpace,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Konten
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Konten Postingan',
                  hintText: 'Tuliskan konten postinganmu di sini...',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
                maxLines: 8,
                minLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Cerita tidak boleh kosong.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              // Tombol Aksi
              SizedBox(
                width: double.infinity,
                child: MyButton(
                  onPressed: _isLoading ? null : _submitPost,
                  text: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Posting',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
