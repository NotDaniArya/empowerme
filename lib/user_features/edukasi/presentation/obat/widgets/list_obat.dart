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
      body: _buildBody(context, obatState),
    );
  }

  Widget _buildBody(BuildContext context, ObatState state) {
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

    if (state.obat == null || state.obat!.isEmpty) {
      return const Center(child: Text('Tidak ada obat yang ditemukan.'));
    }

    return ListView.builder(
      itemCount: state.obat!.length,
      itemBuilder: (context, index) {
        final obat = state.obat![index];
        return Card(
          elevation: 5,
          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailObatScreen(obat: obat),
                ),
              );
            },
            child: ListTile(
              title: Text(
                obat.title,
                style: textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Container(
                margin: const EdgeInsets.only(top: TSizes.smallSpace),
                child: Text(
                  obat.source,
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
