import 'package:flutter/material.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/history_jadwal_screen.dart';

import '../../../../../utils/constant/colors.dart';

class CardJadwal extends StatelessWidget {
  const CardJadwal({super.key, required this.tipeJadwal});

  final TipeJadwal tipeJadwal;

  @override
  Widget build(BuildContext context) {
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
