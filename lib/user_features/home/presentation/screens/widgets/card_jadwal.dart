import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/history_jadwal_screen.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../providers/user_jadwal_pasien_provider.dart';

class CardJadwal extends ConsumerWidget {
  const CardJadwal({super.key, required this.tipeJadwal});

  final TipeJadwal tipeJadwal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userJadwalState = tipeJadwal == TipeJadwal.terapi
        ? ref.watch(userJadwalTerapiViewModel)
        : ref.watch(userJadwalAmbilObatViewModel);

    if (userJadwalState.isLoading) {
      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Center(child: CircularProgressIndicator()),
        ),
      );
    }

    if (userJadwalState.error != null) {
      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
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
        ),
      );
    }

    if (userJadwalState.jadwalPasien == null ||
        userJadwalState.jadwalPasien!.isEmpty) {
      return SizedBox(
        width: double.infinity,
        height: 200,
        child: Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Anda tidak memiliki jadwal terapi',
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
        ),
      );
    }

    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => tipeJadwal == TipeJadwal.terapi
                  ? const HistoryJadwalScreen(tipeJadwal: TipeJadwal.terapi)
                  : const HistoryJadwalScreen(tipeJadwal: TipeJadwal.ambilObat),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Lihat Selengkapnya',
                  textAlign: TextAlign.end,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge!.copyWith(color: TColors.primaryColor),
                ),
              ),
              const Divider(height: 24),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildInfoRow(
                          context,
                          icon: Icons.calendar_today,
                          text: 'Senin, 17 Agustus 2025',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          icon: Icons.access_time,
                          text: '18.00 WITA',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          icon: Icons.location_on,
                          text: 'RS Grestelina',
                        ),
                        const SizedBox(height: 8),
                        _buildInfoRow(
                          context,
                          icon: Icons.person,
                          text: 'Bertemu dengan Yudhoyono',
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
