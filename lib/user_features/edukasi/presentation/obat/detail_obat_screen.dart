import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';

class DetailObatScreen extends StatelessWidget {
  const DetailObatScreen({super.key, required this.obat});

  final Obat obat;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: TColors.primaryColor,
              foregroundColor: Colors.white,
              expandedHeight: 300.0,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                background: CachedNetworkImage(
                  imageUrl:
                      'https://res.cloudinary.com/dk0z4ums3/image/upload/v1650279033/attached_image/lopinavir-ritonavir.jpg',
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
                      obat.title,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: TSizes.smallSpace),
                    Text(
                      obat.source,
                      textAlign: TextAlign.center,
                      style: textTheme.titleSmall!.copyWith(
                        color: TColors.secondaryText,
                      ),
                    ),
                    const SizedBox(height: TSizes.mediumSpace),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        obat.date,
                        style: textTheme.titleSmall!.copyWith(),
                      ),
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Category : Berita',
                        style: textTheme.titleSmall!.copyWith(),
                      ),
                    ),
                    const Divider(color: Colors.black54),
                    const SizedBox(height: TSizes.mediumSpace),
                    Text(obat.description, textAlign: TextAlign.justify),
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
                          final Uri url = Uri.parse(obat.link);
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
      ),
    );
  }
}
