import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/home/presentation/screens/widgets/information_slider.dart';

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
                Container(
                  padding: const EdgeInsets.all(8).copyWith(top: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: TColors.primaryColor.withOpacity(0.1),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                      const Divider(
                        color: TColors.primaryColor,
                        thickness: 0.8,
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rumah sakit Faizal',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Senin, 26 Juli 2025',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black87),
                              ),
                              Text(
                                '18.00 WITA',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/icons/jadwal_terapi.png',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSections),

                /*
                ==========================================
                Container jadwal terapi
                ==========================================
                */
                Text(
                  'Jadwal Ambil Obat',
                  style: textTheme.bodyLarge!.copyWith(
                    // color: TColors.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: TSizes.smallSpace),
                Container(
                  padding: const EdgeInsets.all(8).copyWith(top: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: TColors.primaryColor.withOpacity(0.1),
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
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
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
                      const Divider(
                        color: TColors.primaryColor,
                        thickness: 0.8,
                      ),
                      const SizedBox(height: TSizes.smallSpace),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rumah sakit Faizal',
                                style: Theme.of(context).textTheme.bodyLarge!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Senin, 26 Juli 2025',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black87),
                              ),
                              Text(
                                '18.00 WITA',
                                style: Theme.of(context).textTheme.bodySmall!
                                    .copyWith(color: Colors.black87),
                              ),
                            ],
                          ),
                          Image.asset(
                            'assets/icons/jadwal_terapi.png',
                            height: 100,
                            fit: BoxFit.cover,
                          ),
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
                const SizedBox(height: TSizes.mediumSpace),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
