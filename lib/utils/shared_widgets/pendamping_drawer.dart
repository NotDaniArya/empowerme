import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/tambah_edukasi/presentations/create_berita_sheet.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/screen/edukasi_screen.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/komunitas_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/shared_widgets/pendamping_menu_item.dart';

import '../../pendamping_features/tambah_edukasi/presentations/create_panduan_sheet.dart';

class PendampingDrawer extends StatelessWidget {
  const PendampingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  TColors.primaryColor,
                  TColors.primaryColor.withOpacity(0.8),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'EmpowerMe',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Column(
            children: [
              PendampingMenuItem(
                title: 'Edukasi',
                iconData: FontAwesomeIcons.bookMedical,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EdukasiScreen(),
                    ),
                  );
                },
              ),
              PendampingMenuItem(
                title: 'Komunitas',
                iconData: FontAwesomeIcons.peopleGroup,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const KomunitasScreen(),
                    ),
                  );
                },
              ),
              PendampingMenuItem(
                title: 'Tambah Edukasi Panduan',
                iconData: FontAwesomeIcons.addressBook,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const CreatePanduanSheet(),
                  );
                },
              ),
              PendampingMenuItem(
                title: 'Tambah Berita',
                iconData: FontAwesomeIcons.addressBook,
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const CreateBeritaSheet(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
