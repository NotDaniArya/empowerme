import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/utils/constant/colors.dart';

import '../../../../utils/constant/sizes.dart';
import '../providers/pasien_provider.dart';

class DaftarPasienScreen extends ConsumerStatefulWidget {
  const DaftarPasienScreen({super.key});

  @override
  ConsumerState<DaftarPasienScreen> createState() => _DaftarPasienScreen();
}

class _DaftarPasienScreen extends ConsumerState<DaftarPasienScreen> {
  // 1. Tambahkan state untuk pencarian
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Tambahkan listener untuk mendeteksi setiap ketikan
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pasienState = ref.watch(pasienViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(title: const Text('Daftar Pasien')),
      // Gunakan Column untuk menampung Search Bar dan List
      body: Column(
        children: [
          // --- Search Bar ---
          Padding(
            padding: const EdgeInsets.all(TSizes.scaffoldPadding),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama pasien...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // --- Daftar Pasien ---
          // Gunakan Expanded agar ListView mengisi sisa ruang
          Expanded(child: _buildBody(context, pasienState)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, PasienState state) {
    final textTheme = Theme.of(context).textTheme;

    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(child: Text('Terjadi kesalahan: ${state.error}'));
    }

    if (state.pasien == null || state.pasien!.isEmpty) {
      return const Center(child: Text('Tidak ada data pasien.'));
    }

    // 2. Logika untuk memfilter daftar pasien berdasarkan query pencarian
    final allPasien = state.pasien!;
    final filteredPasien = _searchQuery.isEmpty
        ? allPasien
        : allPasien
              .where(
                (pasien) => pasien.name.toLowerCase().contains(
                  _searchQuery.toLowerCase(),
                ),
              )
              .toList();

    if (filteredPasien.isEmpty) {
      return const Center(child: Text('Pasien tidak ditemukan.'));
    }

    // 3. Gunakan daftar yang sudah difilter
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.smallSpace),
      itemCount: filteredPasien.length,
      itemBuilder: (context, index) {
        final pasien = filteredPasien[index];

        // --- Tampilan Kartu yang Lebih Menarik ---
        return Card(
          margin: const EdgeInsets.only(bottom: TSizes.spaceBtwItems),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            onTap: () {
              // TODO: Navigasi ke halaman detail pasien
            },
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            // Gunakan CircleAvatar untuk tampilan yang lebih standar
            leading: CircleAvatar(
              backgroundColor: TColors.primaryColor.withOpacity(0.2),
              child: Text(
                pasien.name.isNotEmpty ? pasien.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: TColors.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              pasien.name,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              pasien.email,
              style: textTheme.bodySmall!.copyWith(
                color: TColors.secondaryText,
              ),
            ),
            trailing: const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ),
        );
      },
    );
  }
}
