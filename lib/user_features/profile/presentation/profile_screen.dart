import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/onboarding/onboarding_screen.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/sizes.dart';
import '../../../utils/shared_widgets/avatar_image.dart';
import '../../../utils/shared_widgets/menu_item.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

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
            const AvatarImage(
              imageUrl:
                  'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
              radius: 50,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            Text(
              'User',
              textAlign: TextAlign.center,
              style: textTheme.headlineSmall!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'user01@gmail.com',
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
                    onTap: () {},
                    leading: const FaIcon(FontAwesomeIcons.user, size: 20),
                  ),
                  const Divider(height: 1, indent: 12, endIndent: 12),
                  MenuItem(
                    title: 'About',
                    onTap: () {},
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
