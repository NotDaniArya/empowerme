import 'package:flutter/material.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class NewMessage extends StatelessWidget {
  const NewMessage({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: TextField(
            textCapitalization: TextCapitalization.sentences,
            autocorrect: true,
            enableSuggestions: true,
            decoration: InputDecoration(labelText: 'Send a message'),
          ),
        ),
        const SizedBox(width: TSizes.mediumSpace),
        IconButton(
          onPressed: () {},
          icon: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
        ),
      ],
    );
  }
}
