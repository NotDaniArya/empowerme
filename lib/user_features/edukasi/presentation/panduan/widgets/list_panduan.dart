import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/panduan/detail_panduan_screen.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/panduan/providers/panduan_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../../../../utils/constant/sizes.dart';

class ListPanduan extends ConsumerWidget {
  const ListPanduan({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final panduanState = ref.watch(panduanViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: _buildBody(context, panduanState, ref),
    );
  }

  Widget _buildBody(BuildContext context, PanduanState state, WidgetRef ref) {
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
                    ref.invalidate(panduanViewModel);
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

    if (state.panduan == null || state.panduan!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tidak ada panduan yang ditemukan.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(panduanViewModel);
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
        ref.invalidate(panduanViewModel);
      },
      child: ListView.builder(
        itemCount: state.panduan!.length,
        itemBuilder: (context, index) {
          final panduan = state.panduan![index];
          return Card(
            elevation: 5,
            color: TColors.secondaryColor,
            clipBehavior: Clip.antiAlias,
            margin: const EdgeInsets.symmetric(
              horizontal: TSizes.mediumSpace,
            ).copyWith(bottom: TSizes.spaceBtwSections),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailPanduanScreen(panduan: panduan),
                  ),
                );
              },
              child: Row(
                children: [
                  CachedNetworkImage(
                    imageUrl: panduan.displayThumbnail,
                    height: 150,
                    width: 120,
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
                  Expanded(
                    child: Container(
                      margin: const EdgeInsetsGeometry.all(4),
                      child: Column(
                        children: [
                          Text(
                            panduan.title,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: textTheme.bodyMedium!.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: TSizes.smallSpace / 2),
                          Text(
                            panduan.publisher,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: textTheme.labelMedium!.copyWith(
                              color: Colors.black,
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
        },
      ),
    );
  }
}
