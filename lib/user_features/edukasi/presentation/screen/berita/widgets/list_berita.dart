import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/providers/berita_provider.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/screen/berita/detail_berita_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class ListBerita extends ConsumerWidget {
  const ListBerita({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final beritaState = ref.watch(beritaViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: _buildBody(context, beritaState),
    );
  }

  Widget _buildBody(BuildContext context, BeritaState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Text(
            'Terjadi kesalahan: ${state.error}',
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.berita == null || state.berita!.isEmpty) {
      return const Center(child: Text('Tidak ada berita yang ditemukan.'));
    }

    return ListView.builder(
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
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8)),
              clipBehavior: Clip.hardEdge,
              child: Stack(
                children: [
                  CachedNetworkImage(
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
    );
  }
}
