import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/colors.dart';
import '../../../auth/domain/entities/auth.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Tonton state otentikasi untuk mendapatkan peran pengguna.
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      // Gunakan .when untuk menangani semua state dari authState (loading, error, data).
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error Sesi: $err')),
        data: (authData) {
          // 2. Tentukan peran pengguna saat data otentikasi tersedia.
          final userRole = authData?.role ?? UserRole.unknown;
          final isPatient = userRole == UserRole.pasien;

          // 3. Pilih provider secara kondisional berdasarkan peran.
          final contactsStateProvider = chatContactsProvider;
          // : nonPasienChatContactsProvider;

          final contactsState = ref.watch(contactsStateProvider);

          // 4. Bangun UI berdasarkan state provider yang dipilih.
          return contactsState.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Gagal memuat kontak: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            data: (contacts) {
              if (contacts.isEmpty) {
                return const Center(child: Text('Belum ada percakapan.'));
              }
              return RefreshIndicator(
                onRefresh: () async => ref.invalidate(contactsStateProvider),
                child: ListView.builder(
                  itemCount: contacts.length,
                  itemBuilder: (context, index) {
                    final contact = contacts[index];
                    final namaKontak = contact.name == '000005'
                        ? 'Pendamping'
                        : 'Konselor';
                    return ListTile(
                      leading: CircleAvatar(
                        child: Text(
                          namaKontak.isNotEmpty
                              ? namaKontak.substring(0, 1).toUpperCase()
                              : '?',
                        ),
                      ),
                      title: Text(namaKontak),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatScreen(
                              contactId: contact.id,
                              contactName: namaKontak,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
