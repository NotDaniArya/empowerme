import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(child: Divider(thickness: 1, color: Colors.black38)),

        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('Or', style: TextStyle(color: Colors.black38)),
        ),

        Expanded(child: Divider(thickness: 1, color: Colors.black38)),
      ],
    );
  }
}
