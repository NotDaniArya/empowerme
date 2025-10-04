import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/home/presentation/providers/user_jadwal_pasien_provider.dart';

import '../../../../pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';
import '../../domain/entities/user_jadwal_pasien.dart';

class HistoryJadwalScreen extends ConsumerWidget {
  const HistoryJadwalScreen({
    super.key,
    required this.tipeJadwal,
    required this.id,
  });

  final TipeJadwal tipeJadwal;
  final String id;

  Color _getStatusColor(String status) {
    switch (status.toUpperCase()) {
      case 'SELANJUTNYA':
        return Colors.green.shade600;
      case 'TERLEWATKAN':
        return Colors.orange.shade700;
      case 'DIBATALKAN':
        return Colors.red.shade700;
      default:
        return Colors.blueAccent.shade200;
    }
  }

  int _getSortOrder(String status) {
    switch (status.toUpperCase()) {
      case 'SELANJUTNYA':
        return 0;
      case 'TERLEWATKAN':
        return 1;
      case 'DIBATALKAN':
        return 2;
      default:
        return 3;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final userJadwalState = tipeJadwal == TipeJadwal.terapi
        ? ref.watch(userJadwalTerapiViewModel(id))
        : ref.watch(userJadwalAmbilObatViewModel(id));

    final String title = tipeJadwal == TipeJadwal.terapi
        ? 'Riwayat Jadwal Terapi'
        : 'Riwayat Jadwal Ambil Obat';

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          title,
          style: textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(child: _buildContent(context, ref, userJadwalState)),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    UserJadwalPasienState state,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _buildErrorState(context, ref, state.error!);
    }

    final jadwalList = state.jadwalPasien;

    if (jadwalList == null || jadwalList.isEmpty) {
      return _buildEmptyState(context, ref);
    }

    final sortedList = List<UserJadwalPasien>.from(jadwalList);
    sortedList.sort((a, b) {
      final orderA = _getSortOrder(a.status);
      final orderB = _getSortOrder(b.status);
      return orderA.compareTo(orderB);
    });

    return RefreshIndicator(
      onRefresh: () async => ref.invalidate(
        tipeJadwal == TipeJadwal.terapi
            ? userJadwalTerapiViewModel(id)
            : userJadwalAmbilObatViewModel(id),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding),
        itemCount: sortedList.length,
        itemBuilder: (context, index) {
          final jadwal = sortedList[index];
          return _buildJadwalCard(context, jadwal, Theme.of(context).textTheme);
        },
      ),
    );
  }

  Widget _buildJadwalCard(
    BuildContext context,
    UserJadwalPasien jadwal,
    TextTheme textTheme,
  ) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: TSizes.mediumSpace),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              backgroundColor: _getStatusColor(jadwal.status),
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
                      _buildInfoRow(
                        context,
                        icon: Icons.calendar_today,
                        text: jadwal.date,
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
                  tipeJadwal == TipeJadwal.terapi
                      ? 'assets/icons/jadwal_terapi.png'
                      : 'assets/icons/jadwal_obat.png',
                  height: 100,
                  width: 100,
                  fit: BoxFit.contain,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, WidgetRef ref, String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(TSizes.scaffoldPadding),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Terjadi kesalahan: Gagal memuat riwayat jadwal',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            ElevatedButton(
              onPressed: () => ref.invalidate(
                tipeJadwal == TipeJadwal.terapi
                    ? userJadwalTerapiViewModel(id)
                    : userJadwalAmbilObatViewModel(id),
              ),
              child: const Text('Refresh'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, WidgetRef ref) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Tidak ada jadwal yang ditemukan.',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: TSizes.spaceBtwItems),
          ElevatedButton(
            onPressed: () => ref.invalidate(
              tipeJadwal == TipeJadwal.terapi
                  ? userJadwalTerapiViewModel(id)
                  : userJadwalAmbilObatViewModel(id),
            ),
            child: const Text('Refresh'),
          ),
        ],
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
