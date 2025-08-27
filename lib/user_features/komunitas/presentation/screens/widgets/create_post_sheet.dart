// lib/user_features/komunitas/presentation/screens/widgets/create_post_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';

// Asumsi Anda punya provider ini untuk membuat postingan baru
// import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';

class CreatePostSheet extends ConsumerStatefulWidget {
  const CreatePostSheet({super.key});

  @override
  ConsumerState<CreatePostSheet> createState() => _CreatePostSheetState();
}

class _CreatePostSheetState extends ConsumerState<CreatePostSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
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

    // Panggil ViewModel Anda untuk membuat postingan
    // Contoh:
    // ref.read(komunitasViewModel.notifier).createPost(
    //   title: _titleController.text,
    //   content: _contentController.text,
    //   onSuccess: () {
    //     if (mounted) {
    //       Navigator.of(context).pop(); // Tutup modal jika berhasil
    //       // Tampilkan notifikasi sukses
    //     }
    //   },
    //   onError: (error) {
    //     if (mounted) {
    //       setState(() => _isLoading = false);
    //       // Tampilkan notifikasi error
    //     }
    //   },
    // );

    // Simulasi proses network
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Postingan berhasil dibuat!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            // Header Pengguna
            const ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                // Ganti dengan gambar profil pengguna yang login
                backgroundImage: NetworkImage(
                  'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                ),
              ),
              title: Text(
                'User',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Bagikan ceritamu'),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            // Input Judul
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Apa topik utama ceritamu?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Judul tidak boleh kosong.';
                }
                return null;
              },
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            // Input Konten
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Cerita Anda',
                hintText: 'Tuliskan ceritamu di sini...',
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
    );
  }
}
