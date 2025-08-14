import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/user_features/home/presentation/providers/user_jadwal_pasien_provider.dart';

import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';

class HistoryJadwalScreen extends ConsumerWidget {
  const HistoryJadwalScreen({super.key, required this.tipeJadwal});

  final TipeJadwal tipeJadwal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userJadwalState = tipeJadwal == TipeJadwal.terapi
        ? ref.watch(userJadwalTerapiViewModel)
        : ref.watch(userJadwalAmbilObatViewModel);

    if (userJadwalState.isLoading) {
      return const Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (userJadwalState.error != null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: TColors.primaryColor,
          foregroundColor: Colors.white,
          title: tipeJadwal == TipeJadwal.terapi
              ? Text(
                  'Riwayat Jadwal Terapi',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  'Riwayat Jadwal Ambil Obat',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi kesalahan: ${userJadwalState.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                IconButton(
                  onPressed: () {
                    tipeJadwal == TipeJadwal.terapi
                        ? ref.invalidate(userJadwalTerapiViewModel)
                        : ref.invalidate(userJadwalAmbilObatViewModel);
                  },
                  icon: const Icon(Icons.refresh),
                  style: IconButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (userJadwalState.jadwalPasien == null ||
        userJadwalState.jadwalPasien!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: AppBar(
          backgroundColor: TColors.primaryColor,
          foregroundColor: Colors.white,
          title: tipeJadwal == TipeJadwal.terapi
              ? Text(
                  'Riwayat Jadwal Terapi',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                )
              : Text(
                  'Riwayat Jadwal Ambil Obat',
                  style: textTheme.titleMedium!.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tidak ada jadwal pasien yang ditemukan.',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              IconButton(
                onPressed: () {
                  tipeJadwal == TipeJadwal.terapi
                      ? ref.invalidate(userJadwalTerapiViewModel)
                      : ref.invalidate(userJadwalAmbilObatViewModel);
                },
                icon: const Icon(Icons.refresh),
                style: IconButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
        title: tipeJadwal == TipeJadwal.terapi
            ? Text(
                'Riwayat Jadwal Terapi',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Text(
                'Riwayat Jadwal Ambil Obat',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: TSizes.scaffoldPadding,
          horizontal: TSizes.smallSpace,
        ),
        child: RefreshIndicator(
          displacement: 10,
          onRefresh: () async {
            tipeJadwal == TipeJadwal.terapi
                ? ref.invalidate(userJadwalTerapiViewModel)
                : ref.invalidate(userJadwalAmbilObatViewModel);
          },
          child: ListView.builder(
            itemCount: userJadwalState.jadwalPasien!.length,
            itemBuilder: (context, index) {
              final jadwal = userJadwalState.jadwalPasien![index];

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                      const Divider(height: 24),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
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
                          tipeJadwal == TipeJadwal.terapi
                              ? Image.asset(
                                  'assets/icons/jadwal_terapi.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'assets/icons/jadwal_obat.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.fitWidth,
                                ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
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
