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
      body: _buildBody(context, makananState),
    );
  }

  Widget _buildBody(BuildContext context, MakananState state) {
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

    if (state.makanan == null || state.makanan!.isEmpty) {
      return const Center(child: Text('Tidak ada makanan yang ditemukan.'));
    }

    return ListView.builder(
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
            child: ListTile(
              title: Text(
                makanan.title,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: TSizes.smallSpace),
                child: Text(
                  makanan.source,
                  maxLines: 1,
                  style: textTheme.labelMedium,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
