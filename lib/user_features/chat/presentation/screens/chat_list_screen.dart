import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/chat/presentation/providers/chat_provider.dart';
import 'package:new_empowerme/utils/shared_widgets/appbar.dart';

import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Aktifkan service chat
    ref.watch(chatServiceProvider);

    final contactsState = ref.watch(chatContactsProvider);

    return Scaffold(
      appBar: const MyAppBar(), // Ganti dengan app bar yang sesuai
      body: contactsState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (contacts) {
          if (contacts.isEmpty) {
            return const Center(child: Text('Belum ada percakapan.'));
          }
          return ListView.builder(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              final contact = contacts[index];
              return ListTile(
                leading: CircleAvatar(
                  child: Text(contact.name.substring(0, 1)),
                ),
                title: Text(contact.name),
                subtitle: const Text(
                  "Pesan terakhir...",
                ), // Implementasi di masa depan
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(contactId: contact.id),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
