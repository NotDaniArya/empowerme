import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/history_jadwal_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class DetailPasienScreen extends ConsumerWidget {
  const DetailPasienScreen({super.key, required this.pasien});

  final Pasien pasien;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Detail Pasien'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildProfileHeader(context, pasien),

            Padding(
              padding: const EdgeInsets.all(TSizes.scaffoldPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionTitle(context, 'Informasi Detail'),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _buildInfoTile(
                          icon: Icons.email_outlined,
                          title: 'Email Pasien',
                          value: pasien.email,
                        ),
                        _buildInfoTile(
                          icon: Icons.medication_outlined,
                          title: 'Jenis Obat',
                          value: 'Nama Obat',
                        ),
                        _buildInfoTile(
                          icon: Icons.info_outline,
                          title: 'Status',
                          value:
                              pasien.status[0].toUpperCase() +
                              pasien.status.substring(1).toLowerCase(),
                          valueColor: TColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.edit_note),
                      label: const Text('Ubah Status Pasien'),
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  _buildSectionTitle(context, 'Jadwal Pasien'),
                  const SizedBox(height: TSizes.spaceBtwItems),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          child: const Text('Jadwal Terapi'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryJadwalScreen(
                                  tipeJadwal: TipeJadwal.terapi,
                                  id: pasien.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: OutlinedButton(
                          child: const Text('Jadwal Obat'),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HistoryJadwalScreen(
                                  tipeJadwal: TipeJadwal.ambilObat,
                                  id: pasien.id,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, Pasien pasien) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
      decoration: const BoxDecoration(
        color: TColors.primaryColor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        children: [
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 60)),
          const SizedBox(height: TSizes.spaceBtwItems),
          Text(
            pasien.name,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(
        context,
      ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    Color? valueColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: TColors.primaryColor),
      title: Text(title, style: const TextStyle(color: Colors.grey)),
      subtitle: Text(
        value,
        style: TextStyle(color: valueColor ?? Colors.black, fontSize: 16),
      ),
    );
  }
}
