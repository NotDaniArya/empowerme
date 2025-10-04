import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/berita/providers/berita_provider.dart';
import 'package:new_empowerme/utils/constant/images.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../edukasi/presentation/berita/detail_berita_screen.dart';

class InformationSlider extends ConsumerStatefulWidget {
  const InformationSlider({super.key});

  @override
  ConsumerState<InformationSlider> createState() => _InformationSlider();
}

class _InformationSlider extends ConsumerState<InformationSlider> {
  int _currentIndex = 0;
  final _controller = CarouselSliderController();
  final _informationHomeScreenImage = MyImages.informationHomeScreen;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final beritaState = ref.watch(beritaViewModel);

    return _buildBody(context, beritaState);
  }

  Widget _buildBody(BuildContext context, BeritaState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const SizedBox(
        height: 160,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Terjadi kesalahan: Gagal memuat daftar berita',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(beritaViewModel);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (state.berita == null || state.berita!.isEmpty) {
      return const Center(child: Text('Tidak ada berita yang ditemukan.'));
    }

    final limitedBeritaList = state.berita!.take(3).toList();

    final currentBerita = limitedBeritaList.isNotEmpty
        ? state.berita![_currentIndex]
        : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailBeritaScreen(berita: currentBerita!),
              ),
            );
          },
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Carousel Slider
              CarouselSlider(
                items: limitedBeritaList
                    .map(
                      (beritaItem) => ClipRRect(
                        borderRadius: BorderRadiusGeometry.circular(8),
                        child: Hero(
                          tag: beritaItem.title,
                          child: CachedNetworkImage(
                            // height: 200,
                            imageUrl: beritaItem.displayImageUrl,
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

              if (currentBerita != null)
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
                          currentBerita.title,
                          textAlign: TextAlign.center,
                          style: textTheme.bodySmall!.copyWith(
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: TSizes.smallSpace / 2),
                        Text(
                          currentBerita.author ?? 'Sumber Tidak Diketahui',
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
        const SizedBox(height: TSizes.smallSpace),
        // Indikator Titik (Dots)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: limitedBeritaList.asMap().entries.map((entry) {
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
