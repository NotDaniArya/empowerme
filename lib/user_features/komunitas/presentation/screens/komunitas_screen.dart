import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/create_post_sheet.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import 'detail_komunitas_screen.dart';

class KomunitasScreen extends ConsumerWidget {
  const KomunitasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final komunitasState = ref.watch(komunitasViewModel);

    if (komunitasState.isLoading) {
      return const Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: MyAppBar(),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (komunitasState.error != null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: const MyAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Terjadi kesalahan: ${komunitasState.error}',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(komunitasViewModel);
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

    if (komunitasState.communityPosts == null ||
        komunitasState.communityPosts!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: const MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Belum ada postingan dikomunitas. Jadilah yang pertama membuat postingan',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(komunitasViewModel);
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
        ),
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 80), // Sesuaikan margin
          child: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                builder: (context) => const CreatePostSheet(),
              );
            },
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16), // Bentuk sedikit kotak
            ),
            backgroundColor: TColors.primaryColor,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: TColors.secondaryColor,

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
        child: RefreshIndicator(
          displacement: 10,
          onRefresh: () async {
            ref.invalidate(komunitasViewModel);
            ref.invalidate(commentViewModel);
          },
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              vertical: TSizes.smallSpace / 2,
            ),
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
                                    borderRadius: BorderRadiusGeometry.circular(
                                      50,
                                    ),
                                  ),
                                  clipBehavior: Clip.antiAlias,
                                  child: CircleAvatar(
                                    backgroundColor: TColors.primaryColor
                                        .withOpacity(0.2),
                                    child: Text(
                                      postingan.pasien!.name.isNotEmpty
                                          ? postingan.pasien!.name[0]
                                                .toUpperCase()
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
                      judul threads
                      ==========================================
                      */
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          postingan.content,
                          textAlign: TextAlign.start,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodyMedium,
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
                              final notifier = ref.read(
                                komunitasViewModel.notifier,
                              );
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
          ),
        ),
      ),
    );
  }
}
