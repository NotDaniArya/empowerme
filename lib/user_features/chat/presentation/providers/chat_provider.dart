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
    _fetchInitialMessages();

    _subscription?.cancel(); // Hapus listener lama jika ada

    _subscription = ref.watch(chatServiceProvider).incomingMessages.listen((
      message,
    ) {
      // ===================================================================
      // PERBAIKAN UTAMA & DEFINITIF UNTUK MASALAH DUPLIKAT
      // ===================================================================
      //
      // 1. Abaikan pesan jika pengirimnya (`from`) adalah pengguna saat ini.
      //    Pembaruan optimis di `sendMessage` sudah menangani pesan kita
      //    sendiri, jadi kita tidak perlu memproses gema dari server.
      //    Inilah yang mencegah gelembung obrolan kedua muncul.
      if (message.from == _currentUserId) {
        return; // Hentikan eksekusi jika pesan ini dari kita sendiri
      }

      // 2. Hanya proses pesan jika pengirimnya adalah kontak yang obrolannya
      //    sedang dibuka. Ini memastikan pesan dari obrolan lain tidak
      //    muncul di layar yang salah.
      if (message.from == contactId) {
        final currentMessages = state.valueOrNull ?? [];

        // Cek ID untuk memastikan pesan belum ada (lapisan keamanan tambahan)
        if (!currentMessages.any((m) => m.messageId == message.messageId)) {
          state = AsyncValue.data([...currentMessages, message]);
        }
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
    final repo = ref.read(chatRepositoryProvider);
    final (messages, failure) = await repo.getMessageHistory(
      arg,
    ); // arg adalah contactId
    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(messages ?? []);
    }
  }

  Future<void> sendMessage(String text) async {
    if (_currentUserId == null) return;

    // Buat pesan baru dengan ID unik dari sisi klien
    final message = ChatMessage(
      messageId: const Uuid().v4(),
      from: _currentUserId!,
      to: arg, // arg adalah contactId
      text: text,
      timestamp: DateTime.now(),
      type: MessageType.sent,
    );

    // Pembaruan Optimis: tambahkan pesan ke UI secara langsung
    final currentMessages = state.valueOrNull ?? [];
    state = AsyncValue.data([...currentMessages, message]);

    // Kirim pesan ke server di latar belakang
    await ref.read(chatRepositoryProvider).sendMessage(message);
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      ChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => ChatMessagesViewModel());
