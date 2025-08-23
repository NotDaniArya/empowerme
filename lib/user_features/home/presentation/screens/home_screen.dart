import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/widgets/card_jadwal.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/widgets/information_slider.dart';

import '../../../../pendamping_features/jadwal_pasien/domain/entities/jadwal_pasien.dart';
import '../../../../utils/constant/colors.dart';
import '../../../../utils/constant/sizes.dart';
import '../../../../utils/shared_widgets/appbar.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,

      /*
      ==========================================
      Appbar
      ==========================================
       */
      appBar: const MyAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /*
                ==========================================
                Container jadwal terapi
                ==========================================
                */
                Text(
                  'Jadwal Terapi',
                  style: textTheme.bodyLarge!.copyWith(
                    // color: TColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                const CardJadwal(tipeJadwal: TipeJadwal.terapi, id: '000002'),
                const SizedBox(height: TSizes.spaceBtwSections),

                /*
                ==========================================
                Container jadwal ambil obat
                ==========================================
                */
                Text(
                  'Jadwal Ambil Obat',
                  style: textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                const CardJadwal(
                  tipeJadwal: TipeJadwal.ambilObat,
                  id: '000002',
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /*
                ==========================================
                Container Informasi terbaru
                ==========================================
                */
                Text(
                  'Informasi Terbaru',
                  style: textTheme.bodyLarge!.copyWith(
                    // color: TColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                const InformationSlider(),
                const SizedBox(height: TSizes.mediumSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
