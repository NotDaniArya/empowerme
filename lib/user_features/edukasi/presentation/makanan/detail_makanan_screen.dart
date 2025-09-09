import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/makanan.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';

class DetailMakananScreen extends StatelessWidget {
  const DetailMakananScreen({super.key, required this.makanan});

  final Makanan makanan;

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
                imageUrl: makanan.displayImageUrl,
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
                    makanan.title,
                    textAlign: TextAlign.center,
                    style: textTheme.titleMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // const SizedBox(height: TSizes.smallSpace),
                  Text(
                    makanan.source,
                    textAlign: TextAlign.center,
                    style: textTheme.titleSmall!.copyWith(
                      color: TColors.secondaryText,
                    ),
                  ),
                  const SizedBox(height: TSizes.mediumSpace),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      makanan.date,
                      style: textTheme.titleSmall!.copyWith(),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      'Category : Makanan',
                      style: textTheme.titleSmall!.copyWith(),
                    ),
                  ),
                  const Divider(color: Colors.black54),
                  const SizedBox(height: TSizes.mediumSpace),
                  Text(makanan.description, textAlign: TextAlign.justify),
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
                      onPressed: () {
                        final Uri url = Uri.parse(makanan.link);
                        MyHelperFunction.visitLink(url);
                      },
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
