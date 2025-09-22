import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/makanan/detail_makanan_screen.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/makanan/providers/makanan_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class ListMakanan extends ConsumerWidget {
  const ListMakanan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final makananState = ref.watch(makananViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: _buildBody(context, makananState, ref),
    );
  }

  Widget _buildBody(BuildContext context, MakananState state, WidgetRef ref) {
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
                Text(
                  'Terjadi kesalahan: ${state.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(makananViewModel);
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

    if (state.makanan == null || state.makanan!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tidak ada edukasi makanan yang ditemukan.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(makananViewModel);
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
        ref.invalidate(makananViewModel);
      },
      child: ListView.builder(
        itemCount: state.makanan!.length,
        itemBuilder: (context, index) {
          final makanan = state.makanan![index];
          return Card(
            elevation: 5,
            margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailMakananScreen(makanan: makanan),
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
                    CachedNetworkImage(
                      imageUrl:
                          'https://cdn.rri.co.id/berita/Sendawar/o/1733451900362-WhatsApp_Image_2024-12-06_at_10.24.32/3jzb89gkvbolk71.jpeg',
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
                              makanan.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: TSizes.smallSpace / 2),
                            Text(
                              makanan.source,
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
