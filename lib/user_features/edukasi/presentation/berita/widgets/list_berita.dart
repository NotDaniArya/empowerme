import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/berita/providers/berita_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

import '../detail_berita_screen.dart';

class ListBerita extends ConsumerWidget {
  const ListBerita({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beritaState = ref.watch(beritaViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(child: _buildBody(context, beritaState, ref)),
    );
  }

  Widget _buildBody(BuildContext context, BeritaState state, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.error != null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Terjadi kesalahan: Gagal memuat berita',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(beritaViewModel);
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (state.berita == null || state.berita!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tidak ada berita yang ditemukan.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
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

    return RefreshIndicator(
      displacement: 10,
      onRefresh: () async {
        ref.invalidate(beritaViewModel);
      },
      child: ListView.builder(
        itemCount: state.berita!.length,
        itemBuilder: (context, index) {
          final berita = state.berita![index];
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
                    builder: (context) => DetailBeritaScreen(berita: berita),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  children: [
                    Hero(
                      tag: berita.title,
                      child: CachedNetworkImage(
                        imageUrl: berita.displayImageUrl,
                        height: 150,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
                              berita.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: TSizes.smallSpace / 2),
                            Text(
                              berita.author,
                              maxLines: 1,
                              textAlign: TextAlign.center,
                              style: textTheme.labelMedium!.copyWith(
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
      ),
    );
  }
}
