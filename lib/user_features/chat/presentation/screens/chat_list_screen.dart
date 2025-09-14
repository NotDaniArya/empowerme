import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/constant/colors.dart';
import '../../../auth/domain/entities/auth.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../domain/entities/chat_contact.dart';
import '../providers/chat_provider.dart';
import 'chat_screen.dart';

class ChatListScreen extends ConsumerWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final userRole = authState.valueOrNull?.role ?? UserRole.unknown;

    return Scaffold(
      backgroundColor: TColors.backgroundColor,
      appBar: AppBar(
        title: const Text('Pesan'),
        backgroundColor: TColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          if (userRole == UserRole.pendamping || userRole == UserRole.konselor)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari nama pasien...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (query) =>
                    ref.read(chatSearchQueryProvider.notifier).state = query,
              ),
            ),

          const Expanded(child: _ContactListView()),
        ],
      ),
    );
  }
}

class _ContactListView extends ConsumerWidget {
  const _ContactListView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final contactsState = ref.watch(chatListProvider);
    final searchQuery = ref.watch(chatSearchQueryProvider);

    return contactsState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text('Gagal memuat kontak: $error')),
      data: (contacts) {
        final filteredList = contacts.where((contact) {
          return contact.name.toLowerCase().contains(searchQuery.toLowerCase());
        }).toList();

        if (filteredList.isEmpty) {
          return Center(
            child: Text(
              searchQuery.isEmpty
                  ? 'Belum ada percakapan.'
                  : 'Kontak tidak ditemukan.',
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async => ref.invalidate(chatListProvider),
          child: ListView.builder(
            itemCount: filteredList.length,
            itemBuilder: (context, index) {
              final contact = filteredList[index];
              return _ContactTile(contact: contact);
            },
          ),
        );
      },
    );
  }
}

class _ContactTile extends ConsumerWidget {
  const _ContactTile({required this.contact});

  final ChatContact contact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
      leading: CircleAvatar(
        child: Text(
          contact.name.isNotEmpty
              ? contact.name.substring(0, 1).toUpperCase()
              : '?',
        ),
      ),
      title: Text(contact.name),
      trailing: contact.unreadCount > 0
          ? Badge(label: Text(contact.unreadCount.toString()))
          : null,
      onTap: () {
        if (contact.unreadCount > 0) {
          ref.read(chatListProvider.notifier).markAsRead(contact.id);
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                ChatScreen(contactId: contact.id, contactName: contact.name),
          ),
        );
      },
    );
  }
}
