import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/profile/presentation/change_password_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/providers/profile_provider.dart';
import 'package:toastification/toastification.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/sizes.dart';
import '../../../utils/constant/texts.dart';
import '../../../utils/helper_functions/helper.dart';
import '../../../utils/shared_widgets/input_text_field.dart';
import '../../../utils/shared_widgets/menu_item.dart';
import '../../../utils/shared_widgets/profile_image_picker.dart';
import '../domain/entities/profile.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key, required this.profile});

  final Profile profile;

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreen();
}

class _EditProfileScreen extends ConsumerState<EditProfileScreen> {
  final _form = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();

    // Inisialisasi controller dengan data profil yang ada
    _nameController = TextEditingController(text: widget.profile.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submitEditProfile() async {
    if (!_form.currentState!.validate()) return;

    final isNameChanged = _nameController.text.trim() != widget.profile.name;
    final isImageChanged = _selectedImage != null;

    if (!isNameChanged && !isImageChanged) {
      MyHelperFunction.showToast(
        context,
        'Info',
        'Tidak ada perubahan yang dilakukan',
        ToastificationType.info,
      );
      return;
    }

    try {
      final updater = ref.read(profileUpdaterProvider.notifier);

      if (isNameChanged) {
        await updater.updateProfileName(name: _nameController.text.trim());
      }

      if (isImageChanged) {
        await updater.updateProfilePicture(imageFile: _selectedImage!);
      }

      if (!mounted) return;
      MyHelperFunction.showToast(
        context,
        'Sukses',
        'Profil berhasil diperbarui.',
        ToastificationType.success,
      );
      Navigator.of(context).pop();
    } catch (error) {
      if (!mounted) return;
      MyHelperFunction.showToast(
        context,
        'Gagal',
        'Terjadi kesalahan: ${error.toString()}',
        ToastificationType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(profileUpdaterProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Edit Profil',
          style: textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                      'Edit Profil',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.headlineMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems / 2),
                    Text(
                      'Pastikan data yang anda masukkan adalah data asli dan lengkap untuk memastikan tidak ada masalah.',
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),

                    // widget profile image picker
                    ProfileImagePicker(
                      initialImageUrl:
                          '${TTexts.baseUrl}/images/${widget.profile.picture}',
                      onImageSelected: (image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections),
                    TInputTextField(
                      controller: _nameController,
                      labelText: 'Nama Anda',
                      maxLength: 100,
                      minLength: 4,
                      icon: Icons.person,
                      inputType: TextInputType.name,
                    ),

                    const SizedBox(height: TSizes.spaceBtwSections / 2),
                    Material(
                      color: TColors.secondaryColor,
                      borderRadius: BorderRadiusGeometry.circular(8),
                      clipBehavior: Clip.hardEdge,
                      child: MenuItem(
                        title: 'Ganti Password',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const ChangePasswordScreen(),
                            ),
                          );
                        },
                        leading: const FaIcon(FontAwesomeIcons.lock, size: 20),
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwSections * 1.3),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _submitEditProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: TColors.primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: TColors.primaryColor,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text(
                                'Simpan Perubahan',
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
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
