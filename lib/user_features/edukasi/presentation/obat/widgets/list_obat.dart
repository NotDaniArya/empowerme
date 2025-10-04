import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/obat/detail_obat_screen.dart';
import 'package:new_empowerme/user_features/edukasi/presentation/obat/providers/obat_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class ListObat extends ConsumerWidget {
  const ListObat({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final obatState = ref.watch(obatViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: SafeArea(child: _buildBody(context, obatState, ref)),
    );
  }

  Widget _buildBody(BuildContext context, ObatState state, WidgetRef ref) {
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
                  'Terjadi kesalahan: Gagal memuat daftar edukasi obat',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(obatViewModel);
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

    if (state.obat == null || state.obat!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Tidak ada edukasi obat yang ditemukan.',
                style: textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(obatViewModel);
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
        ref.invalidate(obatViewModel);
      },
      child: ListView.builder(
        itemCount: state.obat!.length,
        itemBuilder: (context, index) {
          final obat = state.obat![index];
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
                    builder: (context) => DetailObatScreen(obat: obat),
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
                      tag: obat.title,
                      child: CachedNetworkImage(
                        imageUrl:
                            'https://res.cloudinary.com/dk0z4ums3/image/upload/v1650279033/attached_image/lopinavir-ritonavir.jpg',
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
                              obat.title,
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              style: textTheme.bodyMedium!.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: TSizes.smallSpace / 2),
                            Text(
                              obat.source,
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
