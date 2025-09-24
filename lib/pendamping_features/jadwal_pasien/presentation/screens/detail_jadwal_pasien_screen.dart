import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/providers/jadwal_pasien_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
import 'package:toastification/toastification.dart';

class DetailJadwalPasienScreen extends ConsumerWidget {
  const DetailJadwalPasienScreen({
    super.key,
    required this.jadwal,
    required this.category,
    required this.tipeJadwal,
  });

  final JadwalPasien jadwal;
  final String category;
  final TipeJadwal tipeJadwal;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Detail Jadwal',
          style: textTheme.titleMedium!.copyWith(color: Colors.white),
        ),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, 'Informasi Pasien'),
              Card(
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    jadwal.pasien.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(jadwal.pasien.email),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildSectionTitle(context, 'Detail Jadwal'),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status:',
                            style: TextStyle(color: TColors.secondaryText),
                          ),
                          _buildStatusChip(context, jadwal.status),
                        ],
                      ),
                      const Divider(height: 24),
                      _buildInfoRow(
                        context,
                        icon: Icons.calendar_today,
                        title: 'Tanggal',
                        value: DateFormat(
                          'EEEE, d MMMM yyyy',
                          'id_ID',
                        ).format(jadwal.date),
                      ),
                      _buildInfoRow(
                        context,
                        icon: Icons.access_time,
                        title: 'Waktu',
                        value: jadwal.time,
                      ),
                      _buildInfoRow(
                        context,
                        icon: Icons.location_on,
                        title: 'Lokasi',
                        value: jadwal.location,
                      ),
                      _buildInfoRow(
                        context,
                        icon: Icons.group,
                        title: 'Bertemu Dengan',
                        value: jadwal.meetWith,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              _buildSectionTitle(context, 'Aksi'),
              if (jadwal.status != 'SELESAI' && jadwal.status != 'DIBATALKAN')
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _updateStatus(ref, context, 'SELESAI');
                        },
                        icon: const Icon(
                          Icons.check_circle,
                          color: Colors.white,
                        ),
                        label: const Text('Selesai'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _updateStatus(ref, context, 'DIBATALKAN');
                        },
                        icon: const Icon(Icons.cancel, color: Colors.white),
                        label: const Text('Batalkan'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                )
              else
                Card(
                  color: Colors.grey.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Center(
                      child: Text(
                        'Aksi tidak tersedia untuk status ini.',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: TColors.primaryColor),
          const SizedBox(width: 16),
          Text(
            '$title: ',
            style: const TextStyle(color: TColors.secondaryText),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BuildContext context, String status) {
    Color backgroundColor;
    Color foregroundColor;
    IconData icon;

    switch (status) {
      case 'SELESAI':
        backgroundColor = Colors.green.shade100;
        foregroundColor = Colors.green.shade800;
        icon = Icons.check_circle;
        break;
      case 'DIBATALKAN':
        backgroundColor = Colors.red.shade100;
        foregroundColor = Colors.red.shade800;
        icon = Icons.cancel;
        break;
      case 'DATANG':
        backgroundColor = Colors.blue.shade100;
        foregroundColor = Colors.blue.shade800;
        icon = Icons.hourglass_top;
        break;
      default:
        backgroundColor = Colors.orange.shade100;
        foregroundColor = Colors.orange.shade800;
        icon = Icons.info;
        break;
    }

    return Chip(
      avatar: Icon(icon, color: foregroundColor, size: 18),
      label: Text(
        status[0].toUpperCase() + status.substring(1).toLowerCase(),
        style: Theme.of(context).textTheme.labelLarge!.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
    );
  }

  void _updateStatus(WidgetRef ref, BuildContext context, String newStatus) {
    final updateFunction = tipeJadwal == TipeJadwal.terapi
        ? ref.read(jadwalPasienUpdaterProvider.notifier).updateStatusTerapi
        : ref.read(jadwalPasienUpdaterProvider.notifier).updateStatusAmbilObat;

    updateFunction(
      idJadwal: jadwal.idJadwal, // Konversi ke int
      status: newStatus,
      onSuccess: () {
        if (!context.mounted) return;
        MyHelperFunction.showToast(
          context,
          'Jadwal berhasil diupdate',
          'Status jadwal telah diubah menjadi $newStatus',
          ToastificationType.success,
        );
        Navigator.pop(context);
      },
      onError: (error) {
        if (!context.mounted) return;
        MyHelperFunction.showToast(
          context,
          'Gagal mengupdate jadwal',
          'Status jadwal gagal diubah menjadi $newStatus',
          ToastificationType.error,
        );
      },
    );
  }
}
