import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../utils/constant/sizes.dart';

class PostCardShimmer extends StatelessWidget {
  const PostCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      enabled: true,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: TSizes.smallSpace / 2),
        itemCount: 7,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: TSizes.smallSpace / 2),
            color: Colors.white,
            padding: const EdgeInsets.all(TSizes.largeSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.black12,
                    ),
                    const SizedBox(width: TSizes.smallSpace),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(width: 120, height: 10, color: Colors.white),
                        const SizedBox(height: 5),
                        Container(width: 80, height: 8, color: Colors.white),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
                const SizedBox(height: 5),
                Container(
                  width: double.infinity,
                  height: 12,
                  color: Colors.white,
                ),
                const SizedBox(height: 5),
                Container(width: 150, height: 12, color: Colors.white),
              ],
            ),
          );
        },
      ),
    );
  }
}
