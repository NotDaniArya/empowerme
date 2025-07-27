import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../constant/colors.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key, required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      foregroundColor: Colors.white,
      backgroundColor: TColors.primaryColor,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: textTheme.titleMedium!.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadiusGeometry.circular(50),
            ),
            clipBehavior: Clip.antiAlias,
            child: CachedNetworkImage(imageUrl: imageUrl),
          ),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
