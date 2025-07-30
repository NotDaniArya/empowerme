import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/shared_widgets/message_bubble.dart';

class ChatMessages extends StatelessWidget {
  const ChatMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return const MessageBubble.first(
          username: 'User',
          message: 'Halooo',
          isMe: true,
          userImage:
              'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
        );
      },
    );
  }
}
