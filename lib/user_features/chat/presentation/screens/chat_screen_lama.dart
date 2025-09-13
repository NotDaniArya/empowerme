// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:new_empowerme/utils/constant/colors.dart';
// import 'package:new_empowerme/utils/constant/sizes.dart';
//
// import '../../konselor/presentation/screens/chat_konselor_screen.dart';
// import '../../pendamping/chat_pendamping_screen.dart';
//
// class ChatScreenLama extends StatelessWidget {
//   const ChatScreenLama({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final textTheme = Theme.of(context).textTheme;
//
//     return Scaffold(
//       backgroundColor: TColors.backgroundColor,
//       appBar: AppBar(
//         backgroundColor: TColors.primaryColor,
//         foregroundColor: Colors.white,
//         title: Text(
//           'Chat',
//           style: textTheme.titleMedium!.copyWith(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(TSizes.mediumSpace),
//           child: Column(
//             children: [
//               /*
//               ==========================================
//               Chat konselor
//               ==========================================
//               */
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ChatKonselorScreen(),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadiusGeometry.circular(50),
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
//                             ),
//                           ),
//                           const SizedBox(width: TSizes.mediumSpace),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Konselor',
//                                 style: textTheme.bodyMedium!.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 'Ayo segera periksa!',
//                                 style: textTheme.bodySmall!.copyWith(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Text(
//                         '18.40',
//                         style: textTheme.labelMedium!.copyWith(
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: TSizes.smallSpace),
//
//               /*
//               ==========================================
//               Chat pendamping
//               ==========================================
//               */
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => const ChatPendampingScreen(),
//                     ),
//                   );
//                 },
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           Container(
//                             width: 45,
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadiusGeometry.circular(50),
//                             ),
//                             clipBehavior: Clip.antiAlias,
//                             child: CachedNetworkImage(
//                               imageUrl:
//                                   'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
//                             ),
//                           ),
//                           const SizedBox(width: TSizes.mediumSpace),
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 'Pendamping',
//                                 style: textTheme.bodyMedium!.copyWith(
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 'Saatnya Ambil Obat!',
//                                 style: textTheme.bodySmall!.copyWith(
//                                   color: Colors.black54,
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                       Text(
//                         '09.40',
//                         style: textTheme.labelMedium!.copyWith(
//                           color: Colors.black54,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
