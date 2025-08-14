import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/screens/daftar_pasien_screen.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/screens/jadwal_pasien_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/profile_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

class PendampingNavigationMenu extends StatefulWidget {
  const PendampingNavigationMenu({super.key});

  @override
  State<PendampingNavigationMenu> createState() =>
      _PendampingNavigationMenuState();
}

class _PendampingNavigationMenuState extends State<PendampingNavigationMenu> {
  int _selectedIndex = 0; // State untuk melacak tab yang aktif

  static final List<Widget> _listMenu = [
    // const HomeScreen(),
    Container(color: Colors.cyan),
    const JadwalPasienScreen(),
    const DaftarPasienScreen(),
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
      backgroundColor: TColors.backgroundColor,
      extendBody: true, // Membuat body bisa berada di belakang navbar
      body: _listMenu[_selectedIndex],

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

          clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              // Item Navigasi di Kiri
              _buildNavItem(
                icon: Icons.dashboard,
                label: 'Dashboard',
                index: 0,
              ),
              _buildNavItem(
                icon: FontAwesomeIcons.calendarDays,
                label: 'Jadwal Pasien',
                index: 1,
              ),

              // Item Navigasi di Kanan
              _buildNavItem(
                icon: FontAwesomeIcons.addressBook,
                label: 'Daftar Pasien',
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
    final textTheme = Theme.of(context).textTheme;

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
              style: textTheme.labelMedium!.copyWith(
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
