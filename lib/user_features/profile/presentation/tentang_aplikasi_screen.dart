import 'package:flutter/material.dart';

import '../../../utils/constant/colors.dart';
import '../../../utils/helper_functions/helper.dart';

class TentangAplikasiScreen extends StatelessWidget {
  const TentangAplikasiScreen({super.key});

  // widget untuk membuat FAQ item
  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 8.0,
          ).copyWith(bottom: 16),
          child: Text(answer, style: const TextStyle(height: 1.5)),
        ),
      ],
    );
  }

  // widget untuk membuat item kontak
  Widget _buildContactItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: TColors.primaryColor, size: 30),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        onTap: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Bantuan & Informasi'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- bagian FAQ ---
            Text(
              'Pertanyaan Umum (FAQ)',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'Kenapa saya tidak memiliki jadwal Terapi atau jadwal ambil obat?',
              'Anda akan memiliki jadwal tersebut apabila pendamping melakukan pembuatan jadwal bagi anda. Untuk saat ini hanya pendamping yang bisa membuat jadwal terapi atau ambil obat pengguna, pengguna tidak punya dapat membuat jadwalnya sendiri.',
            ),
            _buildFaqItem(
              'Dimana saya dapat melakukan diskusi mengenai jadwal terapi atau jadwal ambil obat saya?',
              'Anda dapat menggunakan fitur chat ke pendamping untuk mendiskusikan jadwal anda. Konselor tidak mempunyai hak untuk mengatur jadwal terapi dan jadwal ambil obat anda jadi jangan salah chat ya.',
            ),
            _buildFaqItem(
              'Apakah identitas saya aman atau identitas saya diketahui oleh pengguna/pengidap lain?',
              'Aplikasi kami sangat menjunjung tinggi privasi dan kenyamanan para pengguna. Pengguna tidak akan dapat melihat detail pengguna lain seperti nama, email, dan foto profil. Nama, email, dan foto profil hanya dapat dilihat oleh pendamping dan konselor untuk dapat membantu mereka dalam berkomunikasi kepada para pengguna/pengidap atau melakukan pekerjaan mereka.',
            ),
            _buildFaqItem(
              'Kenapa saya tidak bisa berkomunikasi dengan konselor?',
              'Hal itu terjadi karena status anda bukan pengguna baru. Hanya pengguna baru yang dapat berkomunikasi dengan konselor untuk melakukan konsultasi awal apabila belum atau masih kurang pengetahuan mengeani HIV. Akses status pengguna hanya dimiliki oleh pendamping.',
            ),

            const Divider(height: 40),

            // --- Bagian Hubungi Kami ---
            Text(
              'Hubungi Kami',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildContactItem(
              context: context,
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'empowerme383@gmail.com',
              onTap: () {
                // Ganti email dengan email Anda
                MyHelperFunction.launchURL(
                  'mailto:empowerme383@gmail.com?subject=Bantuan Aplikasi',
                );
              },
            ),

            const Divider(height: 40),

            // --- Bagian Tentang Aplikasi ---
            Center(
              child: Column(
                children: [
                  Text(
                    'Empowerme',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Versi 1.0.0',
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
