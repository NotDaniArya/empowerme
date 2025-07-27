import 'package:flutter/material.dart';
import 'package:new_empowerme/features/profile/presentation/profile_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import 'features/home/presentation/screens/home_screen.dart';

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
    Container(),
    Container(),
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
      // Tampilkan layar yang sesuai dengan indeks yang dipilih
      body: _listMenu.elementAt(_selectedIndex),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.perm_device_information),
            label: 'Informasi',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: 'Komunitas'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onSelectedMenu,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withAlpha(150),
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: TColors.primaryColor,
      ),
    );
  }
}
