import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MyButton extends StatelessWidget {
  const MyButton({super.key, required this.text, required this.onPressed});

  final Widget text;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: TColors.primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusGeometry.circular(8),
        ),
        padding: const EdgeInsetsGeometry.symmetric(
          vertical: 10,
          horizontal: 30,
        ),
      ),
      child: text,
    );
  }
}
