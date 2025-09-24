import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:toastification/toastification.dart';

import '../../../../../utils/constant/texts.dart';
import '../../../../../utils/helper_functions/helper.dart';

class CommentSheet extends ConsumerStatefulWidget {
  const CommentSheet({
    super.key,
    required this.parentComment,
    required this.komunitasId,
  });

  final Comment parentComment;
  final String komunitasId;

  @override
  ConsumerState<CommentSheet> createState() => _CommentSheetState();
}

class _CommentSheetState extends ConsumerState<CommentSheet> {
  final _replyController = TextEditingController();

  @override
  void dispose() {
    _replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commentState = ref.watch(commentViewModel(widget.komunitasId));
    late final Comment updatedParentComment;
    final textTheme = Theme.of(context).textTheme;

    try {
      updatedParentComment = commentState.commentCommunity!.firstWhere(
        (c) => c.id == widget.parentComment.id,
      );
    } catch (e) {
      updatedParentComment = widget.parentComment;
    }
    final replies = updatedParentComment.replyComment ?? [];

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          height: MediaQuery.of(context).size.height * 0.9,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Balasan Komentar',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const Divider(height: 24),
              _buildParentComment(context, updatedParentComment),
              const Divider(height: 24),

              Expanded(
                child: replies.isEmpty
                    ? const Center(child: Text('Belum ada balasan.'))
                    : RefreshIndicator(
                        displacement: 10,
                        onRefresh: () async {
                          ref.invalidate(komunitasViewModel);
                          ref.invalidate(commentViewModel);
                        },
                        child: ListView.builder(
                          itemCount: replies.length,
                          itemBuilder: (context, index) {
                            final reply = replies[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                  '${TTexts.baseUrl}/images/${reply.pasien.picture}',
                                ),
                              ),
                              title: Text(
                                reply.pasien.name,
                                style: textTheme.labelSmall!.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                reply.comment,
                                style: textTheme.bodyMedium,
                              ),
                            );
                          },
                        ),
                      ),
              ),

              _buildCommentInputField(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildParentComment(BuildContext context, Comment comment) {
    final textTheme = Theme.of(context).textTheme;
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(
          '${TTexts.baseUrl}/images/${comment.pasien.picture}',
        ),
      ),
      title: Text(
        comment.pasien.name,
        style: textTheme.labelSmall!.copyWith(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(comment.comment, style: textTheme.bodyMedium),
      dense: true,
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _replyController,
              maxLines: null,
              decoration: InputDecoration(
                hintText: 'Tulis balasan...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              final commentText = _replyController.text.trim();
              if (commentText.isEmpty) {
                return;
              }

              ref
                  .read(komunitasUpdaterProvider.notifier)
                  .addReplyComment(
                    id: widget.parentComment.id!,
                    comment: commentText,
                    onSuccess: () {
                      _replyController.clear();
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
            },
            icon: const Icon(Icons.send, color: TColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
