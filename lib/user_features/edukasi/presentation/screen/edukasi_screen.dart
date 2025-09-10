import 'package:flutter/material.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/makanan/widgets/list_makanan.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/obat/widgets/list_obat.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/panduan/widgets/list_panduan.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import '../berita/widgets/list_berita.dart';

class EdukasiScreen extends StatefulWidget {
  const EdukasiScreen({super.key});

  @override
  State<EdukasiScreen> createState() => _EdukasiScreenState();
}

class _EdukasiScreenState extends State<EdukasiScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabSelection);
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
                    'Panduan & Edukasi Seputar HIV/AIDS',
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
                  labelPadding: const EdgeInsetsGeometry.symmetric(
                    horizontal: 8,
                  ),
                  tabs: const [
                    Tab(text: 'Panduan'),
                    Tab(text: 'Berita'),
                    Tab(text: 'Makanan'),
                    Tab(text: 'Obat'),
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
                    children: [
                      const ListPanduan(),
                      const ListBerita(),
                      const ListMakanan(),
                      const ListObat(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 90,
            right: 10.0,
            child: Visibility(
              visible: _tabController.index == 0,
              child: FloatingActionButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(12),
                ),

                backgroundColor: TColors.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
