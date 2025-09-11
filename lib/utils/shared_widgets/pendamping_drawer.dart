import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../user_features/edukasi/presentation/panduan/widgets/create_panduan_sheet.dart';

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
                  'Empowerme',
                  style: Theme.of(
                    context,
                  ).textTheme.headlineLarge!.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: ListTile(
              leading: FaIcon(
                FontAwesomeIcons.bookMedical,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              title: Text(
                'Tambah Edukasi Panduan',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
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
          ),
        ],
      ),
    );
  }
}
