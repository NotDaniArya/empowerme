import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/constant/images.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

import '../../../../../utils/constant/colors.dart';

class InformationSlider extends StatefulWidget {
  const InformationSlider({super.key});

  @override
  State<InformationSlider> createState() => _InformationSlider();
}

class _InformationSlider extends State<InformationSlider> {
  int _currentIndex = 0;
  final _controller = CarouselSliderController();
  final _informationHomeScreenImage = MyImages.informationHomeScreen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.bottomCenter,
          children: [
            // Carousel Slider
            CarouselSlider(
              items: _informationHomeScreenImage
                  .map(
                    (banner) => ClipRRect(
                      borderRadius: BorderRadiusGeometry.circular(8),
                      child: CachedNetworkImage(
                        // height: 200,
                        imageUrl: banner,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        progressIndicatorBuilder:
                            (context, url, downloadProgress) => Center(
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ),
                  )
                  .toList(),
              carouselController: _controller,
              options: CarouselOptions(
                viewportFraction: 1.0,
                aspectRatio: 16 / 9,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 5),
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
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
                      'IDAI: Anak Sehat dan Cerdas Jadi Kunci Menuju Indonesia Emas 2045',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: TSizes.smallSpace / 2),
                    Text(
                      'Detik.com',
                      textAlign: TextAlign.center,
                      style: textTheme.bodySmall!.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: TSizes.smallSpace),
        // Indikator Titik (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _informationHomeScreenImage.asMap().entries.map((entry) {
            final index = entry.key;
            return GestureDetector(
              onTap: () => _controller.animateToPage(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                width: _currentIndex == index ? 24.0 : 8.0,
                // Lebar berubah saat aktif
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: TColors.primaryColor.withOpacity(
                    _currentIndex == index ? 1 : 0.5,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
