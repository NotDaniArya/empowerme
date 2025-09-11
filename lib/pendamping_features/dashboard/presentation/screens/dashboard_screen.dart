import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:new_empowerme/pendamping_features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:new_empowerme/utils/constant/colors.dart';
import 'package:new_empowerme/utils/constant/sizes.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import '../../../../utils/shared_widgets/pendamping_drawer.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(dashboardViewModel);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: const MyAppBar(),
      drawer: const PendampingDrawer(),
      body: RefreshIndicator(
        onRefresh: () async => ref.invalidate(dashboardViewModel),
        color: TColors.primaryColor,
        child: _buildBody(context, dashboardState, ref),
      ),
    );
  }

  Widget _buildBody(BuildContext context, DashboardState state, WidgetRef ref) {
    if (state.isLoading && state.dashboard == null) {
      return const _DashboardSkeleton();
    }

    if (state.error != null && state.dashboard == null) {
      return _buildErrorState(context, state.error!, ref);
    }

    if (state.dashboard == null) {
      return const Center(child: Text('Data tidak tersedia.'));
    }

    final dashboard = state.dashboard!;
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Hari Ini',
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
            'Berikut adalah data terbaru pasien Anda.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          // --- PERUBAHAN DARI GridView KE Wrap ---
          Wrap(
            spacing: 16, // Jarak horizontal antar kartu
            runSpacing: 16, // Jarak vertikal antar baris kartu
            children: [
              _DashboardCard(
                icon: FontAwesomeIcons.userGroup,
                title: 'Total Pasien',
                value: dashboard.totalPatientCount.toString(),
                color: Colors.blue.shade700,
              ),
              _DashboardCard(
                icon: FontAwesomeIcons.calendarCheck,
                title: 'Jadwal Terapi Selanjutnya', // Judul lebih panjang
                value: dashboard.scheduledTherapyCount.toString(),
                color: Colors.green.shade700,
              ),
              _DashboardCard(
                icon: FontAwesomeIcons.pills,
                title: 'Jadwal Ambil Obat Selanjutnya',
                value: dashboard.scheduledMedicationCount.toString(),
                color: Colors.orange.shade700,
              ),
              _DashboardCard(
                icon: FontAwesomeIcons.calendarXmark,
                title: 'Jadwal Terapi yang Sudah Lewat',
                value: dashboard.missedTherapyCount.toString(),
                color: Colors.red.shade700,
              ),
              // Kartu ini akan memakan lebar penuh jika diperlukan
              _DashboardCard(
                icon: FontAwesomeIcons.capsules,
                title: 'Jadwal Ambil Obat yang Sudah Lewat',
                value: dashboard.missedMedicationCount.toString(),
                color: Colors.purple.shade700,
              ),
            ],
          ),
          const SizedBox(height: TSizes.scaffoldPadding * 4),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String error, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              color: TColors.primaryColor,
              size: 60,
            ),
            const SizedBox(height: 16),
            Text(
              'Gagal Memuat Data',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () =>
                  ref.read(dashboardViewModel.notifier).fetchDashboard(),
              icon: const Icon(Icons.refresh, color: Colors.white),
              label: const Text(
                'Coba Lagi',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: TColors.primaryColor,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  const _DashboardCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    // Menghitung lebar kartu agar pas untuk 2 kolom
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth =
        (screenWidth - (16 * 3)) / 2; // (Lebar layar - (padding * 3)) / 2 kolom

    return Container(
      width: cardWidth,
      constraints: const BoxConstraints(minHeight: 150), // Tinggi minimum kartu
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: FaIcon(icon, color: Colors.white, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              // --- PERUBAHAN PADA JUDUL ---
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
                // Tidak ada batasan baris, teks akan otomatis wrap
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DashboardSkeleton extends StatelessWidget {
  const _DashboardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: TColors.primaryColor),
    );
  }
}
