import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/onboarding/onboarding_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/edit_profile_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/providers/profile_provider.dart';
import 'package:new_empowerme/user_features/profile/presentation/tentang_aplikasi_screen.dart';
import 'package:new_empowerme/utils/constant/texts.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/sizes.dart';
import '../../../utils/shared_widgets/menu_item.dart';
import '../../komunitas/presentation/providers/komunitas_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModel);

    return _buildBody(context, profileState, ref);
  }

  Widget _buildBody(BuildContext context, ProfileState state, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi kesalahan: ${state.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(profileViewModel);
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.profile == null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Anda belum login',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(komunitasViewModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      /*
      ==========================================
      Foto Profil
      ==========================================
      */
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 48,
          horizontal: 24,
        ),
        child: Column(
          children: [
            ClipOval(
              child: SizedBox(
                width: 120,
                height: 120,
                child: CachedNetworkImage(
                  imageUrl:
                      '${TTexts.baseUrl}/images/${state.profile!.picture}',
                  fit: BoxFit.cover,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                        child: SizedBox(
                          width: 120,
                          height: 120,
                          child: CircularProgressIndicator(
                            color: TColors.primaryColor.withOpacity(0.5),
                          ),
                        ),
                      ),
                  errorWidget: (context, url, error) => const CircleAvatar(
                    radius: 50,
                    backgroundColor: TColors.backgroundColor,
                    child: Icon(Icons.person, color: TColors.primaryColor),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              state.profile!.name,
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              state.profile!.email,
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium!.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /*
            ==========================================
            Item Profil
            ==========================================
            */
            Material(
              color: TColors.secondaryColor,
              borderRadius: BorderRadiusGeometry.circular(8),
              clipBehavior: Clip.hardEdge,
              child: Column(
                children: [
                  MenuItem(
                    title: 'Profile Saya',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditProfileScreen(profile: state.profile!),
                        ),
                      );
                    },
                    leading: const FaIcon(FontAwesomeIcons.user, size: 20),
                  ),
                  const Divider(height: 1, indent: 12, endIndent: 12),
                  MenuItem(
                    title: 'Informasi dan Bantuan',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TentangAplikasiScreen(),
                        ),
                      );
                    },
                    leading: const FaIcon(
                      FontAwesomeIcons.circleInfo,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /*
            ==========================================
            Button logout
            ==========================================
            */
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showLogoutConfirmationDialog(context, ref),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(8),
                  ),
                  side: const BorderSide(color: Colors.red),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text(
                  'Logout',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // method untuk tampilkan dialog konfirmasi logout
  void _showLogoutConfirmationDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar dari akun Anda?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(ctx).pop(); // Tutup dialog
              },
            ),
            TextButton(
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
              onPressed: () {
                ref.watch(authNotifierProvider.notifier).logout();

                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const OnboardingScreen(),
                  ),
                  (route) => false,
                );

                if (Navigator.canPop(ctx)) {
                  Navigator.of(ctx).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
