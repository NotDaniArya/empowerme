import 'package:flutter/material.dart';

class MyTextButton extends StatelessWidget {
  const MyTextButton({
    super.key,
    required this.text,
    required this.buttonText,
    this.route,
  });

  final Widget text;
  final Widget buttonText;
  final Widget? route;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        text,
        const SizedBox(width: 5),
        TextButton(
          onPressed: () {
            route == null
                ? null
                : Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => route!),
                  );
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
          ),
          child: buttonText,
        ),
      ],
    );
  }
}
