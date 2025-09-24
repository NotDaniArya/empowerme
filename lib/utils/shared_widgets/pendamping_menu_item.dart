import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class PendampingMenuItem extends StatelessWidget {
  const PendampingMenuItem({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
  });

  final String title;
  final IconData iconData;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(TSizes.smallSpace / 2),
      child: ListTile(
        leading: FaIcon(
          iconData,
          size: 20,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}
