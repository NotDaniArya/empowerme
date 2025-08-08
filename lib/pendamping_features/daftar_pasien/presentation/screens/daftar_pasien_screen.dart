import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/jadwal_pasien/presentation/providers/pasien_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../../../utils/constant/sizes.dart';

class DaftarPasienScreen extends ConsumerStatefulWidget {
  const DaftarPasienScreen({super.key});

  @override
  ConsumerState<DaftarPasienScreen> createState() => _DaftarPasienScreen();
}

class _DaftarPasienScreen extends ConsumerState<DaftarPasienScreen> {
  @override
  Widget build(BuildContext context) {
    final pasienState = ref.watch(pasienViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      body: _buildBody(context, pasienState),
    );
  }

  Widget _buildBody(BuildContext context, PasienState state) {
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

    if (state.pasien == null || state.pasien!.isEmpty) {
      return const Center(child: Text('Tidak ada pasien yang ditemukan.'));
    }

    return SafeArea(
      child: ListView.builder(
        itemCount: state.pasien!.length,
        itemBuilder: (context, index) {
          final pasien = state.pasien![index];

          return Card(
            elevation: 3,
            color: TColors.secondaryColor,
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsetsGeometry.symmetric(
                horizontal: 16,
              ),
              leading: const FaIcon(FontAwesomeIcons.solidUser),
              title: Text(pasien.name, style: textTheme.bodyLarge),
              subtitle: Text(
                pasien.email,
                style: textTheme.bodySmall!.copyWith(
                  color: TColors.secondaryText,
                ),
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios,
                color: TColors.primaryColor,
              ),
            ),
          );
        },
      ),
    );
  }
}
