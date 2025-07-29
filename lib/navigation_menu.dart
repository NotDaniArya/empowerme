import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/screen/edukasi_screen.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/home_screen.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/komunitas_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/profile_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  static final List<Widget> _listMenu = [
    // const HomeScreen(),
    const HomeScreen(),
    const EdukasiScreen(),
    const KomunitasScreen(),
    const ProfileScreen(),
  ];

  void _onSelectedMenu(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Membuat body bisa berada di belakang navbar
      body: _listMenu[_selectedIndex],

      // 1. Floating Action Button (Tombol Tengah)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aksi saat tombol + ditekan
        },
        shape: const CircleBorder(),
        backgroundColor: TColors.primaryColor,
        child: const FaIcon(FontAwesomeIcons.userDoctor, color: Colors.white),
      ),

      // 2. Lokasi FAB di tengah dan "menempel"
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // 3. Gunakan BottomAppBar, bukan BottomNavigationBar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Anda bisa atur warna bar di sini
          boxShadow: [
            BoxShadow(
              // Atur warna dan transparansi bayangan
              color: Colors.black.withOpacity(0.18),
              // Atur tingkat blur
              blurRadius: 20,
              // Atur seberapa menyebar bayangannya
              spreadRadius: 5,
              // KUNCI UTAMA: Atur posisi bayangan (x, y)
              // Nilai y negatif berarti bayangan akan bergeser ke atas
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: BottomAppBar(
          color: Colors.white,
          shape: const CircularNotchedRectangle(), // Membuat lekukan
          notchMargin: 10.0, // Jarak antara FAB dan lekukan
          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Item Navigasi di Kiri
              _buildNavItem(
                icon: FontAwesomeIcons.home,
                label: 'Home',
                index: 0,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.bookMedical,
                label: 'Edukasi',
                index: 1,
              ),

              // Item Navigasi di Kanan
              _buildNavItem(
                icon: FontAwesomeIcons.peopleGroup,
                label: 'Komunitas',
                index: 2,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.solidUser,
                label: 'Profile',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper widget untuk membuat setiap item navigasi agar kode tidak berulang
  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final color = isSelected ? TColors.primaryColor : Colors.grey;

    return InkWell(
      onTap: () => _onSelectedMenu(index),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
