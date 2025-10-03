import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/widgets/history_navigation_card.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/widgets/information_slider.dart';

import '../../../../pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_widgets/appbar.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'history_jadwal_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: const MyAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: authState.when(
              data: (authData) {
                if (authData == null) {
                  return const Center(
                    child: Text(
                      'Pengguna tidak ditemukan. Silakan login ulang.',
                    ),
                  );
                }
                return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Akses Cepat Jadwal Anda',
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        Row(
                          children: [
                            Expanded(
                              child: HistoryNavigationCard(
                                icon: FontAwesomeIcons.calendarCheck,
                                title: 'Riwayat Terapi',
                                subtitle: 'Lihat semua jadwal terapi Anda',
                                color: Colors.blue.shade700,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HistoryJadwalScreen(
                                        tipeJadwal: TipeJadwal.terapi,
                                        id: authData.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Expanded(
                              child: HistoryNavigationCard(
                                icon: FontAwesomeIcons.pills,
                                title: 'Riwayat Ambil Obat',
                                subtitle: 'Lihat semua jadwal ambil obat anda',
                                color: Colors.green.shade700,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => HistoryJadwalScreen(
                                        tipeJadwal: TipeJadwal.ambilObat,
                                        id: authData.id,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: TSizes.spaceBtwSections * 1.5),

                        Text(
                          'Informasi Terbaru',
                          style: textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: TSizes.spaceBtwItems),
                        const InformationSlider(),
                      ],
                    )
                    .animate(delay: 70.ms)
                    .fade(duration: 600.ms, curve: Curves.easeOut)
                    .slide(
                      begin: const Offset(0, 0.2),
                      duration: 600.ms,
                      curve: Curves.easeOut,
                    );
              },
              error: (error, stack) =>
                  Center(child: Text('Terjadi kesalahan: $error')),
              loading: () => const Center(
                heightFactor: 10,
                child: CircularProgressIndicator(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
