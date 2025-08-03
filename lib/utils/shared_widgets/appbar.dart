import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/chat/presentation/screens/chat_screen.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppBar(
      foregroundColor: TColors.primaryColor,
      backgroundColor: Colors.white,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 35,
                height: 35,
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(50),
                ),
                clipBehavior: Clip.antiAlias,
                child: CachedNetworkImage(
                  imageUrl:
                      'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                ),
              ),
              const SizedBox(width: TSizes.mediumSpace),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Halo,',
                    style: textTheme.titleMedium!.copyWith(
                      color: TColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'User',
                    style: textTheme.titleSmall!.copyWith(
                      color: TColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
          },
          icon: const FaIcon(FontAwesomeIcons.paperPlane),
        ),
      ],
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight * 1.1);
}
