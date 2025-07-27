import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.leading,
  });

  final String title;
  final VoidCallback onTap;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ListTile(
      leading: leading,
      title: Text(title, style: textTheme.bodyMedium),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }
}
