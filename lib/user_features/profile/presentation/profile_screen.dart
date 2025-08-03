import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/constant/sizes.dart';
import '../../../utils/shared_widgets/avatar_image.dart';
import '../../../utils/shared_widgets/menu_item.dart';
import '../../auth/presentation/screens/login/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      // appBar: AppBar(
      //   centerTitle: true,
      //   automaticallyImplyLeading: false,
      //   title: Text(
      //     'Profile Saya',
      //     style: textTheme.titleMedium!.copyWith(
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
      //   backgroundColor: TColors.primaryColor,
      //   foregroundColor: Colors.white,
      // ),

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
                onPressed: () => _showLogoutConfirmationDialog(context),
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
  void _showLogoutConfirmationDialog(BuildContext context) {
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
                // Navigasi ke halaman login dan hapus semua rute sebelumnya
                Navigator.of(ctx).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
