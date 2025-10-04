import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/auth/domain/entities/auth.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/providers/komunitas_provider.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/create_post_sheet.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/post_card.dart';
import 'package:new_empowerme/user_features/komunitas/presentation/screens/widgets/post_card_shimmer.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

class KomunitasScreen extends ConsumerWidget {
  const KomunitasScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;
    final komunitasState = ref.watch(komunitasViewModel);

    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.valueOrNull?.role ?? UserRole.unknown;

    if (komunitasState.isLoading) {
      return const Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: MyAppBar(),
        body: PostCardShimmer(),
      );
    }

    if (komunitasState.error != null) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: const MyAppBar(),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Terjadi kesalahan: Gagal memuat postingan komunitas',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  onPressed: () {
                    ref.invalidate(komunitasViewModel);
                  },
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    if (komunitasState.communityPosts == null ||
        komunitasState.communityPosts!.isEmpty) {
      return Scaffold(
        backgroundColor: TColors.backgroundColor,
        appBar: const MyAppBar(),
        body: Padding(
          padding: const EdgeInsets.all(TSizes.scaffoldPadding),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Belum ada postingan dikomunitas. Jadilah yang pertama membuat postingan',
                  style: textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                ElevatedButton(
                  onPressed: () {
                    ref.invalidate(komunitasViewModel);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColors.primaryColor,
                  ),
                  child: const Text(
                    'Refresh',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: userRole == UserRole.pendamping
            ? Container(
                margin: const EdgeInsets.only(bottom: 80),
                child: FloatingActionButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20),
                        ),
                      ),
                      builder: (context) => const CreatePostSheet(),
                    );
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  backgroundColor: TColors.primaryColor,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              )
            : null,
      );
    }

    return Scaffold(
      backgroundColor: TColors.secondaryColor,

      /*
      ==========================================
      Appbar
      ==========================================
       */
      appBar: const MyAppBar(),
      body: SafeArea(
        /*
        ==========================================
        ListView
        ==========================================
        */
        child: RefreshIndicator(
          displacement: 10,
          onRefresh: () async {
            ref.invalidate(komunitasViewModel);
            ref.invalidate(commentViewModel);
          },
          child: PostCard(komunitasState: komunitasState),
        ),
      ),
      floatingActionButton: userRole == UserRole.pendamping
          ? Container(
              margin: const EdgeInsets.only(bottom: TSizes.scaffoldPadding),
              child: FloatingActionButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                    ),
                    builder: (context) => const CreatePostSheet(),
                  );
                },
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                backgroundColor: TColors.primaryColor,
                child: const Icon(Icons.add, color: Colors.white),
              ),
            )
          : null,
    );
  }
}
