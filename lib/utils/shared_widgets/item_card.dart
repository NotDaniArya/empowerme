import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:new_empowerme/features/edukasi/presentation/screen/detail_edukasi_screen.dart';

import '../constant/sizes.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.publisherName,
    required this.itemCount,
  });

  final String imageUrl;
  final String title;
  final String publisherName;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Card(
          elevation: 5,
          margin: const EdgeInsets.symmetric(
            horizontal: TSizes.mediumSpace,
          ).copyWith(bottom: TSizes.spaceBtwSections),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DetailEdukasiScreen(),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsetsGeometry.symmetric(
                        vertical: 6,
                        horizontal: 12,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.black45,
                        borderRadius: BorderRadiusGeometry.only(
                          bottomRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: TSizes.smallSpace / 2),
                          Text(
                            publisherName,
                            textAlign: TextAlign.center,
                            style: textTheme.bodySmall!.copyWith(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
