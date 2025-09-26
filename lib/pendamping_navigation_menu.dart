import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/screens/daftar_pasien_screen.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/screens/widgets/tambah_pasien.dart';
import 'package:new_empowerme/pendamping_features/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/providers/jadwal_tab_provider.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/screens/jadwal_pasien_screen.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/screens/tambah_jadwal_screen.dart';
import 'package:new_empowerme/user_features/profile/presentation/profile_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/shared_providers/pendamping_navigation_provider.dart';
import 'package:new_empowerme/utils/shared_widgets/pendamping_drawer.dart';

class PendampingNavigationMenu extends ConsumerWidget {
  const PendampingNavigationMenu({super.key});

  // Daftar layar yang akan ditampilkan di dalam body
  static final List<Widget> _screens = [
    const DashboardScreen(),
    const JadwalPasienScreen(),
    const DaftarPasienScreen(),
    const ProfileScreen(),
  ];

  // Daftar judul untuk setiap layar, agar AppBar dinamis
  static const List<String> _pageTitles = [
    'Dashboard',
    'Jadwal Pasien',
    'Daftar Pasien',
    'Profil',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Dapatkan indeks yang sedang aktif dari provider
    final selectedIndex = ref.watch(navigationIndexProvider);
    // Dapatkan juga indeks tab dari layar jadwal untuk logika FAB
    final activeJadwalTabIndex = ref.watch(jadwalTabProvider);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      extendBody: true, // Membuat body bisa berada di belakang navbar
      // AppBar sekarang terpusat di sini dan judulnya dinamis

      // Drawer hanya akan muncul jika pengguna berada di layar Dashboard (indeks 0)
      drawer: selectedIndex == 0 ? const PendampingDrawer() : null,

      body: _screens[selectedIndex],

      // FloatingActionButton dikelola di sini secara terpusat
      floatingActionButton: _buildFab(
        context,
        selectedIndex,
        activeJadwalTabIndex,
      ),

      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                spreadRadius: 2,
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
                _buildNavItem(
                  context: context,
                  ref: ref,
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  index: 0,
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  icon: FontAwesomeIcons.calendarDays,
                  label: 'Jadwal Pasien',
                  index: 1,
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  icon: FontAwesomeIcons.addressBook,
                  label: 'Daftar Pasien',
                  index: 2,
                ),
                _buildNavItem(
                  context: context,
                  ref: ref,
                  icon: FontAwesomeIcons.solidUser,
                  label: 'Profile',
                  index: 3,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper widget untuk membuat setiap item navigasi.
  Widget _buildNavItem({
    required BuildContext context,
    required WidgetRef ref,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = ref.watch(navigationIndexProvider) == index;
    final color = isSelected ? TColors.primaryColor : Colors.grey;
    final textTheme = Theme.of(context).textTheme;

    return InkWell(
      onTap: () => ref.read(navigationIndexProvider.notifier).state = index,
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

  /// Helper widget untuk membangun FAB secara kondisional.
  Widget? _buildFab(
    BuildContext context,
    int selectedIndex,
    int activeJadwalTabIndex,
  ) {
    // KONDISI 1: Jika di layar Jadwal Pasien (indeks 1)
    if (selectedIndex == 1) {
      return FloatingActionButton(
        onPressed: () {
          final jadwalType = activeJadwalTabIndex == 0
              ? TipeJadwal.terapi
              : TipeJadwal.ambilObat;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TambahJadwalScreen(jadwalType: jadwalType),
            ),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: TColors.primaryColor,
        child: const Icon(Icons.add, color: Colors.white),
      );
    }
    // KONDISI 2: Jika di layar Daftar Pasien (indeks 2)
    else if (selectedIndex == 2) {
      return FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            builder: (context) => const TambahPasien(),
          );
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: TColors.primaryColor,
        child: const Icon(Icons.person_add_alt_1, color: Colors.white),
      );
    }
    // KONDISI LAINNYA: Jangan tampilkan FAB
    return null;
  }
}
