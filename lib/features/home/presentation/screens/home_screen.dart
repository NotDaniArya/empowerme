import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/features/home/presentation/screens/widgets/information_slider.dart';

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
                // const SizedBox(height: TSizes.spaceBtwSections),
                /*
                ==========================================
                Container Cek Kesehatan
                ==========================================
                */
                Text(
                  'Cek Kesehatanmu Sekarang',
                  style: textTheme.bodyLarge!.copyWith(
                    // color: TColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                Card(
                  elevation: 0,
                  color: TColors.primaryColor.withOpacity(
                    0.1,
                  ), // Warna lebih lembut
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: Text(
                      'Sudahkah kamu cek kesehatanmu?',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: TColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Cek kesehatanmu sekarang juga!',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    leading: const Icon(
                      Icons.health_and_safety,
                      color: TColors.primaryColor,
                    ),
                    trailing: const Icon(
                      Icons.arrow_forward_ios,
                      color: TColors.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),
                /*
                ==========================================
                Container history cek kesehatan
                ==========================================
                */
                Text(
                  'Riwayat Cek Kesahatan',
                  style: textTheme.bodyLarge!.copyWith(
                    // color: TColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: BoxBorder.all(
                      color: TColors.primaryColor,
                      width: 0.8,
                    ),
                    color: Colors.white,
                    // REKOMENDASI 4: Tambahkan shadow untuk efek kedalaman
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // REKOMENDASI 5: Gunakan Chip widget
                          Wrap(
                            spacing: 8.0,
                            children: [
                              Chip(
                                label: Text(
                                  '18-03-2025',
                                  style: textTheme.bodySmall,
                                ),
                                padding: EdgeInsets.zero,
                              ),
                              Chip(
                                label: Text(
                                  'Sehat',
                                  style: textTheme.bodySmall!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: TColors.primaryColor,
                                padding: EdgeInsets.zero,
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {},
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                            ),
                            child: Text(
                              'Lihat Selengkapnya',
                              style: Theme.of(context).textTheme.labelLarge!
                                  .copyWith(color: TColors.primaryColor),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                      const Divider(
                        color: TColors.primaryColor,
                        thickness: 0.8,
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Rumah sakit Faizal',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Image.asset('assets/images/checkup.png', height: 60),
                        ],
                      ),
                    ],
                  ),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
