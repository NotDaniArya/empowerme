import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/screen/edukasi_screen.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/home_screen.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/komunitas_screen.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/create_post_sheet.dart';
import 'package:new_empowerme/user_features/profile/presentation/profile_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
  int _selectedIndex = 0;

  static final List<Widget> _listMenu = [
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
      backgroundColor: TColors.backgroundColor,
      extendBody: true,
      body: _listMenu[_selectedIndex],

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
                  icon: FontAwesomeIcons.home,
                  label: 'Home',
                  index: 0,
                ),
                _buildNavItem(
                  icon: FontAwesomeIcons.bookMedical,
                  label: 'Edukasi',
                  index: 1,
                ),

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
      ),
      floatingActionButton: _selectedIndex == 2
          ? FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const CreatePostSheet(),
                );
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              backgroundColor: TColors.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

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
