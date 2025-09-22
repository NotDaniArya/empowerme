import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/comment_sheet.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:toastification/toastification.dart';

import '../../../../utils/helper_functions/helper.dart';
import '../../domain/entities/komunitas.dart';

class DetailKomunitasScreen extends ConsumerStatefulWidget {
  const DetailKomunitasScreen({super.key, required this.komunitas});

  final Komunitas komunitas;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _DetailKomunitasScreenState();
}

class _DetailKomunitasScreenState extends ConsumerState<DetailKomunitasScreen> {
  final commentController = TextEditingController();

  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final komunitasState = ref.watch(komunitasViewModel);
    final Komunitas currentPost;
    final posts = komunitasState.communityPosts ?? [];

    final foundPost = posts.cast<Komunitas?>().firstWhere(
      (post) => post?.id == widget.komunitas.id,
      orElse: () => null,
    );

    currentPost = foundPost ?? widget.komunitas;

    final commentState = ref.watch(commentViewModel(currentPost.id));

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
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              displacement: 10,
              onRefresh: () async {
                await ref.read(komunitasViewModel.notifier).refresh();
                ref.invalidate(commentViewModel(currentPost.id));
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
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
                          child: CircleAvatar(
                            backgroundColor: TColors.primaryColor.withOpacity(
                              0.2,
                            ),
                            child: Text(
                              currentPost.pasien!.name.isNotEmpty
                                  ? currentPost.pasien!.name[0].toUpperCase()
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
                            currentPost.pasien!.name,
                            style: textTheme.labelLarge!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          DateFormat(
                            'd-MM-yyyy, HH:mm',
                            'id_ID',
                          ).format(currentPost.createdAt),
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
                      child: Text(
                        currentPost.content,
                        style: textTheme.bodyMedium,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),

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
                              onPressed: () {
                                final notifier = ref.read(
                                  komunitasViewModel.notifier,
                                );
                                if (currentPost.statusLike) {
                                  notifier.unLikeCommunityPost(
                                    id: currentPost.id,
                                  );
                                } else {
                                  notifier.likeCommunityPost(
                                    id: currentPost.id,
                                  );
                                }
                              },
                              icon: FaIcon(
                                currentPost.statusLike
                                    ? FontAwesomeIcons.solidHeart
                                    : FontAwesomeIcons.heart,
                                size: 18,
                                color: currentPost.statusLike
                                    ? Colors.redAccent
                                    : Colors.black45,
                              ),
                            ),
                            Text(currentPost.like.toString()),
                          ],
                        ),
                        const SizedBox(width: 15),
                        Row(
                          children: [
                            const FaIcon(
                              FontAwesomeIcons.comment,
                              size: 18,
                              color: Colors.black45,
                            ),
                            const SizedBox(width: 15),
                            Text(currentPost.countComment.toString()),
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
                    _buildCommentBody(context, commentState),
                  ],
                ),
              ),
            ),
          ),
          _buildCommentInputField(currentPost.id),
        ],
      ),
    );
  }

  void _showCommentModal(BuildContext context, Comment comment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return CommentSheet(
          parentComment: comment,
          komunitasId: widget.komunitas.id,
        );
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Terjadi kesalahan: ${state.error}',
                textAlign: TextAlign.center,
              ),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(commentViewModel(widget.komunitas.id));
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

    if (state.commentCommunity == null || state.commentCommunity!.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Belum ada komentar.', style: textTheme.titleMedium),
              const SizedBox(height: TSizes.spaceBtwItems),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(commentViewModel(widget.komunitas.id));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: TColors.primaryColor,
                ),
                child: const Text(
                  'Refresh',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: TSizes.spaceBtwSections),
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
            const SizedBox(height: TSizes.spaceBtwItems),

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
                        child: CircleAvatar(
                          backgroundColor: TColors.primaryColor.withOpacity(
                            0.2,
                          ),
                          child: Text(
                            comment.pasien.name.isNotEmpty
                                ? comment.pasien.name[0].toUpperCase()
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
                    _showCommentModal(context, comment);
                  },
                  icon: const FaIcon(FontAwesomeIcons.comment, size: 18),
                ),
                Text(comment.replyCount.toString()),
              ],
            ),
            const Divider(color: Colors.black12),
          ],
        );
      },
    );
  }

  Widget _buildCommentInputField(String postId) {
    return Container(
      padding: const EdgeInsets.all(
        8.0,
      ).copyWith(bottom: MediaQuery.of(context).padding.bottom + 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: TextField(
              controller: commentController,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              submitComment(postId);
            },
            icon: const Icon(Icons.send, color: TColors.primaryColor),
          ),
        ],
      ),
    );
  }

  void submitComment(String postId) {
    if (commentController.text.trim().isEmpty) {
      return;
    }

    ref
        .read(komunitasUpdaterProvider.notifier)
        .addComment(
          id: widget.komunitas.id,
          comment: commentController.text,
          onSuccess: () {
            commentController.clear();
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Sukses',
              'Komentar berhasil ditambahkan.',
              ToastificationType.success,
            );
          },
          onError: (error) {
            if (!mounted) return;
            MyHelperFunction.showToast(
              context,
              'Gagal',
              'Komentar gagal ditambahkan',
              ToastificationType.error,
            );
          },
        );
  }
}
