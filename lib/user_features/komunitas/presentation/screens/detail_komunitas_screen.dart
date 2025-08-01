import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/comment_sheet.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class DetailKomunitasScreen extends StatelessWidget {
  const DetailKomunitasScreen({super.key});

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
        padding: const EdgeInsets.all(TSizes.scaffoldPadding),
        child: SingleChildScrollView(
          child: Column(
            children: [
              /*
              ==========================================
              profile user
              ==========================================
              */
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadiusGeometry.circular(50),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: CachedNetworkImage(
                      imageUrl:
                          'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: TSizes.mediumSpace),
                  Expanded(child: Text('User', style: textTheme.labelLarge)),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /*
              ==========================================
              judul threads
              ==========================================
              */
              Text(
                'ODHIV Bisa Hidup Normal? Jawabannya di Sini!',
                textAlign: TextAlign.start,
                style: textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: TSizes.mediumSpace),

              /*
              ==========================================
              isi threads
              ==========================================
              */
              Text(
                'Saat pertama kali Dika menerima hasil tesnya, dunia seakan runtuh. Ia tak pernah menyangka bahwa tiga huruf kecil—HIV—bisa begitu mengubah hidupnya. Malam itu, ia duduk termenung, mencari jawaban di internet. Apa artinya ini? Apakah hidupnya sudah berakhir? Tapi hari-hari berlalu, dan Dika mulai belajar. Ia menemukan komunitas yang mendukung, dokter yang membimbing, dan orang-orang yang berbagi pengalaman serupa. HIV bukanlah hukuman mati. Dengan terapi ARV yang rutin dan gaya hidup sehat, ia tetap bisa bekerja, berolahraga, dan bahkan menjalin hubungan seperti orang lain. Hari ini, Dika berdiri di depan cermin, tersenyum. Ia telah membuktikan bahwa HIV tidak mendefinisikan siapa dirinya. Ia tetaplah Dika—seorang sahabat, pekerja keras, dan manusia yang berhak atas kehidupan yang penuh makna. Jawabannya? Ya, ODHIV bisa hidup normal. Dan Dika adalah buktinya. 💙',
                style: textTheme.bodyMedium,
              ),
              const SizedBox(height: TSizes.smallSpace),

              /*
              ==========================================
              button like and share
              ==========================================
              */
              Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.heart, size: 18),
                      ),
                      const Text('50'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.comment, size: 18),
                      ),
                      const Text('50'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.share, size: 18),
                      ),
                      const Text('30'),
                    ],
                  ),
                ],
              ),

              /*
              ==========================================
              comments
              ==========================================
              */
              const SizedBox(height: TSizes.mediumSpace),
              const Text('Komentar'),
              const Divider(color: Colors.black12),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 5,
                itemBuilder: (context, index) => Column(
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
                                width: 30,
                                height: 30,
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
                    isi comment
                    ==========================================
                    */
                    Text(
                      'Cerita yang sangat menarik dan menyentuh',
                      textAlign: TextAlign.start,
                      maxLines: 5,
                      style: textTheme.bodyMedium,
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
                          icon: const FaIcon(FontAwesomeIcons.heart, size: 18),
                        ),
                        const Text('50'),
                        IconButton(
                          onPressed: () {
                            _showCommentModal(context);
                          },
                          icon: const FaIcon(
                            FontAwesomeIcons.comment,
                            size: 18,
                          ),
                        ),
                        const Text('100'),
                      ],
                    ),
                    const Divider(color: Colors.black12),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCommentModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return const CommentSheet();
      },
    );
  }
}
