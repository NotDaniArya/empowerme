import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';

import '../../../../../utils/constant/colors.dart';

class CommentSheet extends ConsumerWidget {
  const CommentSheet({super.key, required this.comment});

  final Comment comment;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final replies = comment.replyComment ?? [];
    return Padding(
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

            _buildParentComment(context, comment),
            const Divider(height: 24),

            Expanded(
              child: replies.isEmpty
                  ? const Center(child: Text('Belum ada balasan.'))
                  : ListView.builder(
                      itemCount: replies.length,
                      itemBuilder: (context, index) {
                        final reply = replies[index];
                        return ListTile(
                          leading: const CircleAvatar(
                            backgroundImage: CachedNetworkImageProvider(
                              'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                            ),
                          ),
                          title: Text(
                            reply.pasien.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(reply.comment),
                        );
                      },
                    ),
            ),

            _buildCommentInputField(),
          ],
        ),
      ),
    );
  }

  Widget _buildParentComment(BuildContext context, Comment comment) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: CachedNetworkImageProvider(comment.pasien.picture),
      ),
      title: Text(
        comment.pasien.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(comment.comment),
      dense: true,
    );
  }

  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
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
            onPressed: () {},
            icon: const Icon(Icons.send, color: TColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
