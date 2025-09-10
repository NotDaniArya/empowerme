import 'package:flutter/material.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';
import 'package:new_empowerme/utils/helper_functions/helper.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/shared_widgets/button.dart';

class DetailObatScreen extends StatelessWidget {
  const DetailObatScreen({super.key, required this.obat});

  final Obat obat;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Detail',
          style: textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsetsGeometry.all(TSizes.largeSpace),
        child: Column(
          children: [
            Text(
              obat.title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium!.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // const SizedBox(height: TSizes.smallSpace),
            Text(
              obat.source,
              textAlign: TextAlign.center,
              style: textTheme.titleSmall!.copyWith(
                color: TColors.secondaryText,
              ),
            ),
            const SizedBox(height: TSizes.mediumSpace),
            SizedBox(
              width: double.infinity,
              child: Text(obat.date, style: textTheme.titleSmall!.copyWith()),
            ),
            SizedBox(
              width: double.infinity,
              child: Text(
                'Category : Makanan',
                style: textTheme.titleSmall!.copyWith(),
              ),
            ),
            const Divider(color: Colors.black54),
            const SizedBox(height: TSizes.mediumSpace),
            Text(obat.description, textAlign: TextAlign.justify),
            const SizedBox(height: TSizes.mediumSpace),
            SizedBox(
              width: 250,
              child: MyButton(
                text: const Text(
                  'Baca Selengkapnya',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () {
                  final Uri url = Uri.parse(obat.link);
                  MyHelperFunction.visitLink(url);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
