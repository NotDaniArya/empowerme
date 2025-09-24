import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/widgets/list_jadwal_ambil_obat_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/widgets/list_jadwal_terapi_pasien.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import '../providers/jadwal_tab_provider.dart';

class JadwalPasienScreen extends ConsumerStatefulWidget {
  const JadwalPasienScreen({super.key});

  @override
  ConsumerState<JadwalPasienScreen> createState() => _JadwalPasienScreenState();
}

class _JadwalPasienScreenState extends ConsumerState<JadwalPasienScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    if (_tabController.indexIsChanging) return;
    ref.read(jadwalTabProvider.notifier).state = _tabController.index;
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

      body: SafeArea(
        child: Padding(
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
      ),
    );
  }
}
