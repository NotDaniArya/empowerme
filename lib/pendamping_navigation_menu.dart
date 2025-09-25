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

class PendampingNavigationMenu extends ConsumerStatefulWidget {
  const PendampingNavigationMenu({super.key});

  @override
  ConsumerState<PendampingNavigationMenu> createState() =>
      _PendampingNavigationMenuState();
}

class _PendampingNavigationMenuState
    extends ConsumerState<PendampingNavigationMenu> {
  int _selectedIndex = 0;

  static final List<Widget> _listMenu = [
    const DashboardScreen(),
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
    final activeJadwalTabIndex = ref.watch(jadwalTabProvider);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      extendBody: true,
      body: _listMenu[_selectedIndex],

      floatingActionButton: _buildFab(context, activeJadwalTabIndex),

      bottomNavigationBar: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                spreadRadius: 5,
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
                  icon: Icons.dashboard,
                  label: 'Dashboard',
                  index: 0,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.calendarDays,
                  label: 'Jadwal Pasien',
                  index: 1,
                ),

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
      ),
    );
  }

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

  Widget? _buildFab(BuildContext context, int activeJadwalTabIndex) {
    if (_selectedIndex == 1) {
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
    } else if (_selectedIndex == 2) {
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
    return null;
  }
}
