import 'package:flutter/material.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/screens/tambah_jadwal_screen.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/widgets/list_jadwal_ambil_obat_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/widgets/list_jadwal_terapi_pasien.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

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

      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: TSizes.scaffoldPadding,
              vertical: TSizes.mediumSpace,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
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
                TabBar(
                  controller: _tabController,
                  unselectedLabelColor: Colors.black45,
                  indicatorColor: TColors.primaryColor,
                  labelColor: Colors.black,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                  tabs: const [
                    Tab(text: 'Jadwal Terapi'),
                    Tab(text: 'Jadwal Ambil Obat'),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: const [
                      ListJadwalTerapiPasien(),
                      ListJadwalAmbilObatPasien(),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 90,
            right: 10.0,
            child: FloatingActionButton(
              onPressed: () {
                if (_tabController.index == 0) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahJadwalScreen(
                        jadwalType: TipeJadwal.terapi,
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TambahJadwalScreen(
                        jadwalType: TipeJadwal.ambilObat,
                      ),
                    ),
                  );
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadiusGeometry.circular(12),
              ),

              backgroundColor: TColors.primaryColor,
              child: const Icon(Icons.add, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
