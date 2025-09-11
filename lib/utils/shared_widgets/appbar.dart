import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/user_features/profile/presentation/providers/profile_provider.dart';

import '../../user_features/chat/presentation/screens/chat_screen.dart';
import '../constant/colors.dart';
import '../constant/sizes.dart';
import '../constant/texts.dart';

class MyAppBar extends ConsumerWidget implements PreferredSizeWidget {
  const MyAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileViewModel);

    return _buildBody(context, profileState, ref);
  }

  Widget _buildBody(BuildContext context, ProfileState state, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return AppBar(
        foregroundColor: TColors.primaryColor,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(50),
          ),
          clipBehavior: Clip.antiAlias,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: TColors.primaryColor.withOpacity(0.5),
          ),
        ),
      );
    }

    if (state.error != null) {
      return AppBar(
        foregroundColor: TColors.primaryColor,
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusGeometry.circular(50),
          ),
          clipBehavior: Clip.antiAlias,
          child: Text(
            'Terjadi kesalahan: ${state.error}',
            style: textTheme.labelMedium,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(profileViewModel);
            },
            icon: const Icon(Icons.refresh, color: TColors.primaryColor),
          ),
        ],
      );
    }

    return AppBar(
      foregroundColor: TColors.primaryColor,
      backgroundColor: Colors.white,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipOval(
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: CachedNetworkImage(
                    imageUrl:
                        '${TTexts.baseUrl}/images/${state.profile!.picture}',
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                          child: CircularProgressIndicator(
                            value: downloadProgress.progress,
                            strokeWidth: 2.5,
                            color: TColors.primaryColor.withOpacity(0.5),
                          ),
                        ),
                    // Widget yang ditampilkan jika terjadi error
                    errorWidget: (context, url, error) => const CircleAvatar(
                      radius: 20,
                      backgroundColor: TColors.backgroundColor,
                      child: Icon(Icons.person, color: TColors.primaryColor),
                    ),
                  ),
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
                    state.profile!.name,
                    style: textTheme.titleSmall!.copyWith(
                      color: TColors.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
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
