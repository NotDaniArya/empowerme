import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';
import 'package:new_empowerme/utils/shared_widgets/item_card.dart';

import '../berita/widgets/list_berita.dart';

class EdukasiScreen extends StatefulWidget {
  const EdukasiScreen({super.key});

  @override
  State<EdukasiScreen> createState() => _EdukasiScreenState();
}

class _EdukasiScreenState extends State<EdukasiScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _searchController.dispose();
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
                'Panduan & Edukasi Seputar HIV/AIDS',
                textAlign: TextAlign.center,
                style: textTheme.titleLarge!.copyWith(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

            /*
            ==========================================
            Search box
            ==========================================
            */
            Container(
              margin: const EdgeInsetsGeometry.symmetric(horizontal: 24),
              width: double.infinity,
              child: TextField(
                controller: _searchController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  isDense: true,
                  fillColor: TColors.secondaryColor,
                  filled: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  labelText: 'Cari sesuatu...',
                  hintText: 'Ketik judul...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Icon(Icons.search),
                  ),
                ),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

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
                  const ItemCard(
                    itemCount: 5,
                    imageUrl:
                        'https://akcdn.detik.net.id/community/media/visual/2024/08/24/ilustrasi-hiv-1_169.jpeg?w=700&q=90',
                    title:
                        'Ciri-ciri Terkena HIV: Ini Gejala, Penyebab, dan Penanganannya',
                    publisherName: 'detikJogja.com',
                  ),
                  const ListBerita(),
                  const ItemCard(
                    itemCount: 5,
                    imageUrl:
                        'https://akcdn.detik.net.id/community/media/visual/2024/08/24/ilustrasi-hiv-1_169.jpeg?w=700&q=90',
                    title:
                        'Ciri-ciri Terkena HIV: Ini Gejala, Penyebab, dan Penanganannya',
                    publisherName: 'detikJogja.com',
                  ),
                  const ItemCard(
                    itemCount: 5,
                    imageUrl:
                        'https://akcdn.detik.net.id/community/media/visual/2024/08/24/ilustrasi-hiv-1_169.jpeg?w=700&q=90',
                    title:
                        'Ciri-ciri Terkena HIV: Ini Gejala, Penyebab, dan Penanganannya',
                    publisherName: 'detikJogja.com',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
