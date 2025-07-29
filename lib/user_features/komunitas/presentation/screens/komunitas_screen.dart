import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/detail_komunitas_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

class KomunitasScreen extends StatelessWidget {
  const KomunitasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,

      /*
      ==========================================
      Appbar
      ==========================================
       */
      appBar: const MyAppBar(),
      body: SafeArea(
        /*
        ==========================================
        ListView
        ==========================================
        */
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: TSizes.scaffoldPadding),
          itemCount: 5,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DetailKomunitasScreen(),
                  ),
                );
              },
              /*
              ==========================================
              Container Threads
              ==========================================
              */
              child: Container(
                margin: const EdgeInsets.only(bottom: TSizes.smallSpace),
                color: TColors.primaryColor.withOpacity(0.1),
                padding: const EdgeInsetsGeometry.all(TSizes.mediumSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    /*
                    ==========================================
                    Header threads
                    ==========================================
                    */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadiusGeometry.circular(
                                    50,
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: TSizes.smallSpace),
                              Expanded(
                                child: Text(
                                  'User',
                                  style: textTheme.labelLarge,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: TSizes.spaceBtwSections),
                        Text(
                          '29 Juli 2025',
                          style: textTheme.labelMedium!.copyWith(
                            color: TColors.secondaryText,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /*
                    ==========================================
                    judul threads
                    ==========================================
                    */
                    Text(
                      'Kenapa Stigma tentang HIV Masih Kuat? Ayo Diskusi!',
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      style: textTheme.bodyLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

                    /*
                    ==========================================
                    Likes dan comments button
                    ==========================================
                    */
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: const FaIcon(FontAwesomeIcons.heart),
                        ),
                        const Text('50'),
                        const SizedBox(width: TSizes.mediumSpace),
                        const FaIcon(FontAwesomeIcons.comment),
                        const SizedBox(width: TSizes.mediumSpace),
                        const Text('100'),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
