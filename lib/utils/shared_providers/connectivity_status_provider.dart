import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Enum untuk merepresentasikan semua kemungkinan status koneksi.
enum ConnectivityStatus { online, offline, checking }

class ConnectivityNotifier extends StateNotifier<ConnectivityStatus> {
  StreamSubscription? _subscription;

  ConnectivityNotifier() : super(ConnectivityStatus.checking) {
    // Memeriksa status awal saat notifier pertama kali dibuat.
    _checkInitialStatus();
    // Mendengarkan perubahan konektivitas di masa mendatang.
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _checkInitialStatus() async {
    final result = await Connectivity().checkConnectivity();
    _updateStatus(result);
  }

  void _updateStatus(List<ConnectivityResult> result) {
    // Jika hasilnya adalah 'none', berarti offline. Jika tidak, online.
    if (result.contains(ConnectivityResult.none)) {
      state = ConnectivityStatus.offline;
    } else {
      state = ConnectivityStatus.online;
    }
  }

  /// Metode ini memungkinkan UI (tombol "Coba Lagi") untuk memicu
  /// pemeriksaan ulang koneksi secara manual.
  Future<void> recheckConnectivity() async {
    state = ConnectivityStatus.checking;
    await _checkInitialStatus();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

/// Provider global yang bisa diakses dari seluruh aplikasi.
final connectivityNotifierProvider =
    StateNotifierProvider<ConnectivityNotifier, ConnectivityStatus>(
      (ref) => ConnectivityNotifier(),
    );
