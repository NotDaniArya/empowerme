import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../utils/shared_providers/provider.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/chat_local_datasource.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_contact.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

// Providers untuk Data Layer
final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  final authDataSource = ref.watch(authLocalDataSourceProvider);
  return ChatLocalDataSourceImpl(authLocalDataSource: authDataSource);
});

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  return ChatRemoteDataSourceImpl(ref.watch(dioProvider), authLocalDataSource);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDataSourceProvider),
    ref.watch(chatLocalDataSourceProvider),
    ref,
  );
});

// Service untuk mengelola koneksi WebSocket
final chatServiceProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
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

// ViewModel untuk daftar kontak
class ChatContactsViewModel extends Notifier<AsyncValue<List<ChatContact>>> {
  @override
  AsyncValue<List<ChatContact>> build() {
    ref.watch(chatServiceProvider);
    _fetchContacts();
    return const AsyncValue.loading();
  }

  Future<void> _fetchContacts() async {
    state = const AsyncValue.loading();
    final repo = ref.read(chatRepositoryProvider);
    final (contacts, failure) = await repo.getChatContacts();
    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(contacts ?? []);
    }
  }
}

final chatContactsProvider =
    NotifierProvider<ChatContactsViewModel, AsyncValue<List<ChatContact>>>(
      () => ChatContactsViewModel(),
    );

// --- ViewModel untuk pesan dalam satu chat (TELAH DIPERBARUI SECARA TOTAL) ---
class ChatMessagesViewModel
    extends FamilyNotifier<AsyncValue<List<ChatMessage>>, String> {
  StreamSubscription? _subscription;

  @override
  AsyncValue<List<ChatMessage>> build(String contactId) {
    _listenForIncomingMessages();

    // Memanggil alur pengambilan data awal
    _fetchInitialMessages();

    ref.onDispose(() {
      _subscription?.cancel();
    });

    return const AsyncValue.loading();
  }

  String? get _currentUserId => ref.read(authNotifierProvider).value?.id;
  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  /// Alur pengambilan data "Cache-First" yang baru.
  Future<void> _fetchInitialMessages() async {
    state = const AsyncValue.loading();

    // 1. Ambil data dari cache lokal terlebih dahulu
    final (localMessages, localFailure) = await _repo.getLocalMessageHistory(
      arg,
    );

    if (localMessages != null && localMessages.isNotEmpty) {
      // Jika ada data di cache, langsung tampilkan ke UI
      state = AsyncValue.data(localMessages);
    }

    if (localFailure != null) {
      state = AsyncValue.error(localFailure, StackTrace.current);
    }

    // 2. Kemudian, di latar belakang, sinkronkan dengan server
    final (syncedMessages, remoteFailure) = await _repo.syncMessageHistory(arg);

    // 3. Setelah sinkronisasi selesai, perbarui UI dengan data terbaru
    if (syncedMessages != null) {
      state = AsyncValue.data(syncedMessages);
    }

    if (remoteFailure != null && syncedMessages == null) {
      // Hanya tampilkan error remote jika data lokal juga gagal
      state = AsyncValue.error(remoteFailure, StackTrace.current);
    }
  }

  /// Mendengarkan pesan baru dari WebSocket.
  void _listenForIncomingMessages() {
    _subscription?.cancel();
    _subscription = _repo.incomingMessages.listen((message) {
      if (message.from == arg) {
        // arg adalah contactId
        final currentMessages = state.valueOrNull ?? [];
        if (!currentMessages.any((m) => m.messageId == message.messageId)) {
          state = AsyncValue.data([...currentMessages, message]);
        }
      }
    });
  }

  /// Mengirim pesan dengan pembaruan UI optimis.
  Future<void> sendMessage(String text) async {
    if (_currentUserId == null) return;

    final message = ChatMessage(
      messageId: const Uuid().v4(),
      from: _currentUserId!,
      to: arg,
      text: text,
      timestamp: DateTime.now(),
      type: MessageType.sent,
    );

    final currentMessages = state.valueOrNull ?? [];
    state = AsyncValue.data([...currentMessages, message]);

    // Kirim ke server di latar belakang
    await _repo.sendMessage(message);
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      ChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => ChatMessagesViewModel());
