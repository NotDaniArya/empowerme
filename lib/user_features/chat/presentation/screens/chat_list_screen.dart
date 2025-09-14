import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/colors.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: Text(
          'Chat',
          style: textTheme.titleMedium!.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: authState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error Sesi: $err')),
        data: (authData) {
          final contactsState = ref.watch(chatContactsProvider);

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
                onRefresh: () async => ref.invalidate(chatContactsProvider),
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
