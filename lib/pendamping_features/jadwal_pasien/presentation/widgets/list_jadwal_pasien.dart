import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../../../utils/constant/sizes.dart';
import '../providers/jadwal_pasien_provider.dart';

class ListJadwalPasien extends ConsumerStatefulWidget {
  const ListJadwalPasien({super.key});

  @override
  ConsumerState<ListJadwalPasien> createState() => _ListJadwalPasienState();
}

class _ListJadwalPasienState extends ConsumerState<ListJadwalPasien> {
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
    _selectedCategory = _categories.first;
  }

  @override
  Widget build(BuildContext context) {
    final selectedApiKey = _categoryMap[_selectedCategory]!;
    final jadwalState = ref.watch(jadwalPasienViewModel(selectedApiKey));

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildCategoryDropdown(),
            const SizedBox(height: TSizes.spaceBtwSections),
            _buildBody(context, jadwalState),
            const SizedBox(height: TSizes.mediumSpace),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
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
          value: _selectedCategory,
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

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Text(
            'Terjadi kesalahan: ${state.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.jadwalPasien == null || state.jadwalPasien!.isEmpty) {
      return Center(
        child: Text(
          'Tidak ada jadwal pasien yang ditemukan.',
          style: textTheme.titleMedium,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
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
            onTap: () {},
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
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(
                          color: TColors.primaryColor,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                              text: jadwal.date,
                            ),
                            const SizedBox(height: 8),
                            _buildInfoRow(
                              context,
                              icon: Icons.access_time,
                              text: jadwal.time,
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
                        'assets/icons/jadwal_terapi.png',
                        height: 80,
                        width: 80,
                        fit: BoxFit.contain,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
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
