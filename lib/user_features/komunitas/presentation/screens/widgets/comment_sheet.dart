import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constant/colors.dart';

class CommentSheet extends StatelessWidget {
  const CommentSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Padding untuk menyesuaikan dengan keyboard yang mungkin muncul
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        // Atur tinggi modal, misalnya 90% dari tinggi layar
        height: MediaQuery.of(context).size.height * 0.9,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Handle (garis abu-abu di atas)
            Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(height: 16),

            // Judul
            const Text(
              'Komentar',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const Divider(height: 24),

            // Daftar Komentar yang Bisa di-scroll
            Expanded(
              child: ListView.builder(
                itemCount: 7, // Jumlah komentar dummy
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundImage: CachedNetworkImageProvider(
                        // Ganti dengan URL gambar profil yang sesuai
                        'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
                      ),
                    ),
                    title: Text(
                      'User #${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: const Text(
                      'Ini adalah isi komentar yang sangat menarik!',
                    ),
                  );
                },
              ),
            ),

            // Input Field untuk Menambah Komentar Baru
            _buildCommentInputField(),
          ],
        ),
      ),
    );
  }

  // Helper widget untuk input field di bagian bawah
  Widget _buildCommentInputField() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              // Ganti dengan URL gambar profil pengguna saat ini
              'https://photos.peopleimages.com/picture/202304/2693460-thinking-serious-and-profile-of-asian-man-in-studio-isolated-on-a-blue-background.-idea-side-face-and-male-person-contemplating-lost-in-thoughts-or-problem-solving-while-looking-for-a-solution-fit_400_400.jpg',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Tulis komentar...',
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              // Logika untuk mengirim komentar
            },
            icon: const Icon(Icons.send, color: TColors.primaryColor),
          ),
        ],
      ),
    );
  }
}
