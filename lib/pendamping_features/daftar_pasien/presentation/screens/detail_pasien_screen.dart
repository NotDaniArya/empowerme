import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/presentation/providers/pasien_provider.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/history_jadwal_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';
import 'package:toastification/toastification.dart';

class DetailPasienScreen extends ConsumerStatefulWidget {
  const DetailPasienScreen({super.key, required this.pasien});

  final Pasien pasien;

  @override
  ConsumerState<DetailPasienScreen> createState() => _DetailPasienScreenState();
}

class _DetailPasienScreenState extends ConsumerState<DetailPasienScreen> {
  @override
  Widget build(BuildContext context) {
    final detailPasien = widget.pasien;
    final pasienState = ref.watch(pasienViewModel);
    final Pasien currentPasien;
    final pasien = pasienState.pasien ?? [];
    final isLoading = ref.watch(pasienUpdaterProvider);

    final foundPasien = pasien.cast<Pasien?>().firstWhere(
      (pasien) => pasien?.id == detailPasien.id,
      orElse: () => null,
    );

    currentPasien = foundPasien ?? detailPasien;

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
            _buildProfileHeader(context, detailPasien),

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
                          value: currentPasien.email,
                        ),
                        _buildInfoTile(
                          icon: Icons.medication_outlined,
                          title: 'Jenis Obat',
                          value: currentPasien.drug,
                        ),
                        _buildInfoTile(
                          icon: Icons.info_outline,
                          title: 'Status',
                          value:
                              currentPasien.status[0].toUpperCase() +
                              currentPasien.status.substring(1).toLowerCase(),
                          valueColor: TColors.primaryColor,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: TSizes.spaceBtwSections),

                  if (currentPasien.status == 'PENGGUNA BARU')
                    SizedBox(
                      width: double.infinity,
                      child: isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton.icon(
                              icon: const Icon(Icons.edit_note),
                              label: const Text('Ubah Status Pasien'),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text(
                                      'Ubah Status Pasien',
                                      textAlign: TextAlign.center,
                                    ),
                                    content: const Text(
                                      'Ubah status menjadi Pasien Lama?',
                                      textAlign: TextAlign.center,
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          'Batal',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          ref
                                              .read(
                                                pasienUpdaterProvider.notifier,
                                              )
                                              .updateStatus(
                                                id: currentPasien.id,
                                                onSuccess: () {
                                                  MyHelperFunction.showToast(
                                                    context,
                                                    'Berhasil',
                                                    'Status pasien berhasil diubah',
                                                    ToastificationType.success,
                                                  );
                                                  Navigator.pop(context);
                                                },
                                                onError: (error) {
                                                  MyHelperFunction.showToast(
                                                    context,
                                                    'Gagal',
                                                    'Status pasien gagal diubah',
                                                    ToastificationType.error,
                                                  );
                                                },
                                              );
                                        },
                                        child: const Text('Ubah'),
                                      ),
                                    ],
                                  ),
                                );
                              },
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
                                  id: currentPasien.id,
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
                                  id: currentPasien.id,
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
