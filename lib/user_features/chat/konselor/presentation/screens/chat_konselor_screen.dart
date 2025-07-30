import 'package:flutter/material.dart';
import 'package:new_empowerme/user_features/chat/konselor/presentation/screens/widgets/chat_messages.dart';
import 'package:new_empowerme/user_features/chat/konselor/presentation/screens/widgets/new_message.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class ChatKonselorScreen extends StatelessWidget {
  const ChatKonselorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
        title: Text(
          'Konselor',
          style: textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsetsGeometry.all(TSizes.scaffoldPadding),
        child: Column(
          children: [
            Expanded(child: ChatMessages()),
            NewMessage(),
          ],
        ),
      ),
    );
  }
}
