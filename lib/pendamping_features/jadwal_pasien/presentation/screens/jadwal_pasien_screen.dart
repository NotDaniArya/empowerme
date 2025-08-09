import 'package:flutter/material.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/widgets/list_jadwal_pasien.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import '../../../../user_features/edukasi/presentation/berita/widgets/list_berita.dart';

class JadwalPasienScreen extends StatefulWidget {
  const JadwalPasienScreen({super.key});

  @override
  State<JadwalPasienScreen> createState() => _JadwalPasienScreenState();
}

class _JadwalPasienScreenState extends State<JadwalPasienScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: const MyAppBar(),
      body: Padding(
        padding: const EdgeInsetsGeometry.symmetric(
          horizontal: TSizes.scaffoldPadding,
          vertical: TSizes.mediumSpace,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsetsGeometry.symmetric(horizontal: 24),
              width: double.infinity,
              /*
              ==========================================
              Judul
              ==========================================
              */
              child: Text(
                'Jadwal Terapi & Jadwal Ambil Obat Pasien',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge!.copyWith(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: TSizes.mediumSpace),

            /*
            ==========================================
            Tab Bar 4 menu
            ==========================================
            */
            TabBar(
              controller: _tabController,
              unselectedLabelColor: Colors.black45,
              indicatorColor: TColors.primaryColor,
              labelColor: Colors.black,
              labelPadding: const EdgeInsetsGeometry.symmetric(horizontal: 8),
              tabs: const [
                Tab(text: 'Jadwal Terapi'),
                Tab(text: 'Jadwal Ambil Obat'),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /*
            ==========================================
            Isi tab bar
            ==========================================
            */
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [const ListJadwalPasien(), const ListBerita()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
