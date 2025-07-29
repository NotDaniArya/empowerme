import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/button.dart';

import '../../../../utils/constant/colors.dart';

class DetailEdukasiScreen extends StatelessWidget {
  const DetailEdukasiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: TColors.primaryColor,
            foregroundColor: Colors.white,
            expandedHeight: 300.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Detail',
                style: textTheme.titleMedium!.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              background: CachedNetworkImage(
                imageUrl:
                    'https://akcdn.detik.net.id/community/media/visual/2024/08/24/ilustrasi-hiv-1_169.jpeg?w=700&q=90',
                fit: BoxFit.cover,
                width: double.infinity,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),

          // Konten utama halaman
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsetsGeometry.all(TSizes.largeSpace),
              child: Column(
                children: [
                  Text(
                    'Ciri-ciri Terkena HIV: Ini Gejala, Penyebab, dan Penanganannya',
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: TSizes.smallSpace),
                  Text(
                    'detikJogja.com',
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall!.copyWith(
                      color: TColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: TSizes.mediumSpace),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Date : 20 maret 2025',
                      style: textTheme.titleSmall!.copyWith(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Category : Panduan',
                      style: textTheme.titleSmall!.copyWith(),
                    ),
                  ),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: TSizes.mediumSpace),
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',
                    textAlign: TextAlign.justify,
                  ),
                  const Text(
                    'Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.',
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: TSizes.mediumSpace),
                  SizedBox(
                    width: 250,
                    child: MyButton(
                      text: const Text(
                        'Baca Selengkapnya',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
