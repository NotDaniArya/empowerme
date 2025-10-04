import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/screens/detail_jadwal_pasien_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_providers/pendamping_navigation_provider.dart';
import '../providers/jadwal_pasien_provider.dart';

class ListJadwalAmbilObatPasien extends ConsumerStatefulWidget {
  const ListJadwalAmbilObatPasien({super.key});

  @override
  ConsumerState<ListJadwalAmbilObatPasien> createState() =>
      _ListJadwalAmbilObatPasienState();
}

class _ListJadwalAmbilObatPasienState
    extends ConsumerState<ListJadwalAmbilObatPasien> {
  final Map<String, String> _categoryMap = {
    'Semua': 'all',
    'Selesai': 'done',
    'Yang Akan Datang': 'next',
    'Dibatalkan': 'canceled',
    'Hari Ini': 'today',
    'Telah Lewat': 'has_passed',
  };

  late final List<String> _categories;

  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    _categories = _categoryMap.keys.toList();
    final initialFilterKey = ref.read(jadwalCategoryFilterProvider);
    _selectedCategory = _categoryMap.keys.firstWhere(
      (key) => _categoryMap[key] == initialFilterKey,
      orElse: () => _categories.first,
    );

    Future.microtask(
      () => ref.read(jadwalCategoryFilterProvider.notifier).state = 'all',
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedApiKey = _categoryMap[_selectedCategory]!;
    final jadwalState = ref.watch(
      jadwalAmbilObatPasienViewModel(selectedApiKey),
    );

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: Column(
        children: [
          _buildCategoryDropdown(),
          const SizedBox(height: TSizes.spaceBtwItems),
          Expanded(child: _buildBody(context, jadwalState)),
        ],
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          dropdownColor: TColors.backgroundColor,
          value: _selectedCategory,
          style: textTheme.bodyMedium,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: TColors.primaryColor),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedCategory = newValue;
              });
            }
          },
          items: _categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value[0].toUpperCase() + value.substring(1)),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, JadwalPasienState state) {
    final textTheme = Theme.of(context).textTheme;
    final selectedApiKey = _categoryMap[_selectedCategory]!;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(TSizes.scaffoldPadding),
          child: Text(
            'Terjadi kesalahan: Gagal memuat data jadwal ambil obat',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.jadwalPasien == null || state.jadwalPasien!.isEmpty) {
      return Center(
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Text(
                'Tidak ada jadwal pasien yang ditemukan.',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(jadwalAmbilObatPasienViewModel);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      displacement: 10,
      onRefresh: () async {
        ref.invalidate(jadwalAmbilObatPasienViewModel);
      },
      child: ListView.builder(
        itemCount: state.jadwalPasien!.length,
        itemBuilder: (context, index) {
          final jadwal = state.jadwalPasien![index];

          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailJadwalPasienScreen(
                      tipeJadwal: TipeJadwal.ambilObat,
                      jadwal: jadwal,
                      category: selectedApiKey,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Chip(
                          label: Text(
                            jadwal.status[0].toUpperCase() +
                                jadwal.status.substring(1).toLowerCase(),
                            style: textTheme.labelMedium!.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: TColors.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                        ),
                        Text(
                          'Lihat Selengkapnya',
                          style: Theme.of(context).textTheme.labelLarge!
                              .copyWith(color: TColors.primaryColor),
                        ),
                      ],
                    ),
                    const Divider(height: 24),

                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                jadwal.pasien.name,
                                style: Theme.of(context).textTheme.titleLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              _buildInfoRow(
                                context,
                                icon: Icons.calendar_today,
                                text: DateFormat(
                                  'EEEE, d MMMM yyyy',
                                  'id_ID',
                                ).format(jadwal.date),
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                icon: Icons.access_time,
                                text: '${jadwal.time} WITA',
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                icon: Icons.location_on,
                                text: jadwal.location,
                              ),
                              const SizedBox(height: 8),
                              _buildInfoRow(
                                context,
                                icon: Icons.person,
                                text: 'Bertemu dengan ${jadwal.meetWith}',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Image.asset(
                          'assets/icons/jadwal_obat.png',
                          height: 80,
                          width: 80,
                          fit: BoxFit.fitWidth,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey.shade600),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
