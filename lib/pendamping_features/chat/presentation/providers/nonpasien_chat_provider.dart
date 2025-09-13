import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/chat/data/datasources/chat_local_datasource.dart';
import 'package:new_empowerme/user_features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:new_empowerme/user_features/chat/data/repositories/chat_repository_nonpasien_impl.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';
import 'package:new_empowerme/user_features/chat/domain/repositories/chat_repository.dart';
import 'package:new_empowerme/utils/shared_providers/provider.dart';
import 'package:uuid/uuid.dart';

// --- Providers untuk Data Layer ---

final nonPasienchatLocalDataSourceProvider = Provider<ChatLocalDataSource>((
  ref,
) {
  // Ambil dependency AuthLocalDataSource
  final authDataSource = ref.watch(authLocalDataSourceProvider);
  // Suntikkan ke dalam konstruktor
  return ChatLocalDataSourceImpl(authLocalDataSource: authDataSource);
});

// --- Provider yang Telah Diperbarui ---
final nonPasienchatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((
  ref,
) {
  // Ambil dependency AuthLocalDataSource
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  // Suntikkan ke dalam ChatRemoteDataSourceImpl
  return ChatRemoteDataSourceImpl(ref.watch(dioProvider), authLocalDataSource);
});

final chatNonPasienRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryNonPasienImpl(
    ref.watch(nonPasienchatRemoteDataSourceProvider),
    ref.watch(nonPasienchatLocalDataSourceProvider),
    ref,
  );
});

// SERVICE UNTUK MENGELOLA KONEKSI
final nonPasienchatServiceProvider = Provider((ref) {
  final chatRepository = ref.watch(chatNonPasienRepositoryProvider);
  final authState = ref.watch(authNotifierProvider);
  final userId = authState.valueOrNull?.id;

  if (userId != null) {
    chatRepository.connect(userId);
  }

  ref.onDispose(() {
    chatRepository.disconnect();
  });

  return chatRepository;
});

// VIEWMODEL UNTUK DAFTAR KONTAK
class NonPasienChatContactsViewModel
    extends Notifier<AsyncValue<List<ChatContact>>> {
  @override
  AsyncValue<List<ChatContact>> build() {
    _fetchContacts();
    return const AsyncValue.loading();
  }

  Future<void> _fetchContacts() async {
    state = const AsyncValue.loading();
    final repo = ref.read(chatNonPasienRepositoryProvider);
    final (contacts, failure) = await repo.getChatContacts();
    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(contacts ?? []);
    }
  }
}

final nonPasienChatContactsProvider =
    NotifierProvider<
      NonPasienChatContactsViewModel,
      AsyncValue<List<ChatContact>>
    >(() => NonPasienChatContactsViewModel());

// VIEWMODEL UNTUK PESAN DALAM SATU CHAT
class NonPasienChatMessagesViewModel
    extends FamilyNotifier<AsyncValue<List<ChatMessage>>, String> {
  StreamSubscription? _subscription;

  @override
  AsyncValue<List<ChatMessage>> build(String contactId) {
    _fetchInitialMessages();

    // Dengarkan pesan baru
    _subscription = ref
        .watch(nonPasienchatServiceProvider)
        .incomingMessages
        .listen((message) {
          if ((message.from == contactId && message.to == _currentUserId) ||
              (message.to == contactId && message.from == _currentUserId)) {
            final currentMessages = state.valueOrNull ?? [];
            state = AsyncValue.data([...currentMessages, message]);
          }
        });

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const AsyncValue.loading();
  }

  String? get _currentUserId => ref.read(authNotifierProvider).value?.id;

  Future<void> _fetchInitialMessages() async {
    state = const AsyncValue.loading();
    final repo = ref.read(chatNonPasienRepositoryProvider);
    final (messages, failure) = await repo.getMessageHistory(arg);
    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(messages ?? []);
    }
  }

  Future<void> sendMessage(String text) async {
    final message = ChatMessage(
      messageId: const Uuid().v4(),
      from: _currentUserId!,
      to: arg,
      text: text,
      timestamp: DateTime.now(),
      type: MessageType.sent,
    );

    // Tambahkan ke state UI secara optimis
    final currentMessages = state.valueOrNull ?? [];
    state = AsyncValue.data([...currentMessages, message]);

    // Kirim ke server
    await ref.read(chatNonPasienRepositoryProvider).sendMessage(message);
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      NonPasienChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => NonPasienChatMessagesViewModel());
