import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/comment_sheet.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class DetailKomunitasScreen extends ConsumerStatefulWidget {
  const DetailKomunitasScreen({super.key, required this.komunitas});

  final Komunitas komunitas;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailKomunitasScreenState();
}

class _DetailKomunitasScreenState extends ConsumerState<DetailKomunitasScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final commentState = ref.watch(commentViewModel(widget.komunitas.id));

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
                  Expanded(
                    child: Text(
                      widget.komunitas.pasien!.name,
                      style: textTheme.labelLarge,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'd MMMM yyyy, HH:mm',
                      'id_ID',
                    ).format(widget.komunitas.createdAt),
                    style: textTheme.labelMedium!.copyWith(
                      color: TColors.secondaryText,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

              /*
              ==========================================
              judul threads
              ==========================================
              */
              SizedBox(
                width: double.infinity,
                child: Text(
                  widget.komunitas.title,
                  textAlign: TextAlign.start,
                  style: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: TSizes.mediumSpace),

              /*
              ==========================================
              isi threads
              ==========================================
              */
              SizedBox(
                width: double.infinity,
                child: Text(
                  widget.komunitas.content,
                  style: textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),

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
                      Text(widget.komunitas.like.toString()),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.comment, size: 18),
                      ),
                      const Text('ini belum'),
                    ],
                  ),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const FaIcon(FontAwesomeIcons.share, size: 18),
                      ),
                      Text(widget.komunitas.share.toString()),
                    ],
                  ),
                ],
              ),

              /*
              ==========================================
              comments
              ==========================================
              */
              const SizedBox(height: TSizes.spaceBtwItems),
              const Text('Komentar'),
              const Divider(color: Colors.black45),
              const SizedBox(height: TSizes.spaceBtwSections),
              _buildCommentBody(context, commentState),
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

  Widget _buildCommentBody(BuildContext context, CommentState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return Container(
        margin: const EdgeInsets.only(top: TSizes.spaceBtwSections),
        child: const Center(child: CircularProgressIndicator()),
      );
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

    if (state.commentCommunity == null || state.commentCommunity!.isEmpty) {
      return Center(
        child: SizedBox(
          height: 150,
          child: Column(
            children: [
              Text(
                'Tidak ada jadwal pasien yang ditemukan.',
                style: textTheme.titleMedium,
              ),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  // ref.invalidate(jadwalAmbilObatPasienViewModel);
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

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: state.commentCommunity!.length,
      itemBuilder: (context, index) {
        final comment = state.commentCommunity![index];
        return Column(
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
                          borderRadius: BorderRadiusGeometry.circular(50),
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
                          comment.pasien.name,
                          style: textTheme.labelLarge,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
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
            SizedBox(
              width: double.infinity,
              child: Text(
                comment.comment,
                textAlign: TextAlign.start,
                maxLines: 5,
                style: textTheme.bodyMedium,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwSections),

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
                Text(comment.like.toString()),
                IconButton(
                  onPressed: () {
                    _showCommentModal(context);
                  },
                  icon: const FaIcon(FontAwesomeIcons.comment, size: 18),
                ),
                const Text('100'),
              ],
            ),
            const Divider(color: Colors.black12),
          ],
        );
      },
    );
  }
}
