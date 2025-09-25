import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/tambah_edukasi/presentations/create_berita_sheet.dart';
import 'package:new_empowerme/pendamping_features/tambah_edukasi/presentations/create_makanan_sheet.dart';
import 'package:new_empowerme/pendamping_features/tambah_edukasi/presentations/create_obat_sheet.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/screen/edukasi_screen.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/komunitas_screen.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/pendamping_menu_item.dart';

import '../../pendamping_features/tambah_edukasi/presentations/create_panduan_sheet.dart';

class PendampingDrawer extends StatelessWidget {
  const PendampingDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(left: 18, top: TSizes.mediumSpace),
              width: double.infinity,
              child: Text('EmpowerMe', style: textTheme.titleLarge),
            ),
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
              iconData: FontAwesomeIcons.bookOpenReader,
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
              iconData: FontAwesomeIcons.newspaper,
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
            PendampingMenuItem(
              title: 'Tambah Makanan',
              iconData: FontAwesomeIcons.appleWhole,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  builder: (context) => const CreateMakananSheet(),
                );
              },
            ),
            PendampingMenuItem(
              title: 'Tambah Edukasi Obat',
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
                  builder: (context) => const CreateOBatSheet(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
