import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

import '../../../../../utils/constant/colors.dart';
import '../../../../../utils/constant/sizes.dart';
import '../../../../../utils/helper_functions/helper.dart';
import '../../providers/komunitas_provider.dart';
import '../detail_komunitas_screen.dart';

class PostCard extends ConsumerWidget {
  const PostCard({super.key, required this.komunitasState});

  final KomunitasState komunitasState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: TSizes.smallSpace / 2),
      itemCount: komunitasState.communityPosts!.length,
      itemBuilder: (context, index) {
        final postingan = komunitasState.communityPosts![index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DetailKomunitasScreen(komunitas: postingan),
              ),
            );
          },
          /*
                ==========================================
                Container Threads
                ==========================================
                */
          child: Container(
            margin: const EdgeInsets.only(bottom: TSizes.smallSpace / 2),
            color: Colors.white,
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
                              borderRadius: BorderRadiusGeometry.circular(50),
                            ),
                            clipBehavior: Clip.antiAlias,
                            child: CircleAvatar(
                              backgroundColor: TColors.primaryColor.withOpacity(
                                0.2,
                              ),
                              child: Text(
                                postingan.pasien!.name.isNotEmpty
                                    ? postingan.pasien!.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  color: TColors.primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: TSizes.smallSpace),
                          Expanded(
                            child: Text(
                              postingan.pasien!.name,
                              style: textTheme.labelLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: TSizes.spaceBtwSections),
                    Text(
                      DateFormat(
                        'd-MM-yyyy, HH:mm',
                        'id_ID',
                      ).format(postingan.createdAt),
                      style: textTheme.labelMedium!.copyWith(
                        color: TColors.secondaryText,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),

                /*
                      ==========================================
                      isi threads
                      ==========================================
                      */
                SizedBox(
                  width: double.infinity,
                  child: Linkify(
                    onOpen: (link) =>
                        MyHelperFunction.launchUrlPostingan(link.url, context),
                    text: postingan.content,
                    textAlign: TextAlign.start,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodyMedium,
                    linkStyle: textTheme.bodyMedium?.copyWith(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.blue,
                    ),
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
                      onPressed: () {
                        final notifier = ref.read(komunitasViewModel.notifier);
                        if (postingan.statusLike) {
                          notifier.unLikeCommunityPost(id: postingan.id);
                        } else {
                          notifier.likeCommunityPost(id: postingan.id);
                        }
                      },
                      icon: FaIcon(
                        postingan.statusLike
                            ? FontAwesomeIcons.solidHeart
                            : FontAwesomeIcons.heart,
                        size: 18,
                        color: postingan.statusLike
                            ? Colors.redAccent
                            : Colors.black45,
                      ),
                    ),
                    Text(postingan.like.toString()),
                    const SizedBox(width: TSizes.mediumSpace),
                    const FaIcon(
                      FontAwesomeIcons.comment,
                      size: 18,
                      color: Colors.black45,
                    ),
                    const SizedBox(width: TSizes.mediumSpace),
                    Text(postingan.countComment.toString()),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
