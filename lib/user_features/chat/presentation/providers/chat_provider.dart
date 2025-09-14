import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/failure.dart';
import '../../../../pendamping_features/daftar_pasien/presentation/providers/pasien_provider.dart';
import '../../../../utils/shared_providers/provider.dart';
import '../../../auth/domain/entities/auth.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/chat_local_datasource.dart';
import '../../data/datasources/chat_remote_datasource.dart';
import '../../data/repositories/chat_repository_impl.dart';
import '../../domain/entities/chat_contact.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';

final chatLocalDataSourceProvider = Provider<ChatLocalDataSource>((ref) {
  final authDataSource = ref.watch(authLocalDataSourceProvider);
  return ChatLocalDataSourceImpl(authLocalDataSource: authDataSource);
});

final chatRemoteDataSourceProvider = Provider<ChatRemoteDataSource>((ref) {
  final authLocalDataSource = ref.watch(authLocalDataSourceProvider);
  return ChatRemoteDataSourceImpl(ref.watch(dioProvider), authLocalDataSource);
});

final chatRepositoryProvider = Provider<ChatRepository>((ref) {
  final pasienRepository = ref.watch(pasienRepositoryProvider);
  return ChatRepositoryImpl(
    ref.watch(chatRemoteDataSourceProvider),
    ref.watch(chatLocalDataSourceProvider),
    pasienRepository,
    ref,
  );
});

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

class ChatListViewModel extends Notifier<AsyncValue<List<ChatContact>>> {
  @override
  AsyncValue<List<ChatContact>> build() {
    ref.watch(chatServiceProvider);
    final userRole =
        ref.watch(authNotifierProvider).valueOrNull?.role ?? UserRole.unknown;
    _fetchContactsByRole(userRole);
    return const AsyncValue.loading();
  }

  Future<void> _fetchContactsByRole(UserRole role) async {
    state = const AsyncValue.loading();
    final repo = ref.read(chatRepositoryProvider);

    switch (role) {
      case UserRole.pasien:
        final (contacts, failure) = await repo.getPasienChatContacts();
        _updateState(contacts, failure);
        break;
      case UserRole.pendamping:
        final (pasienList, failure) = await repo.getSortedPatientList();
        final contacts = pasienList
            ?.map((p) => ChatContact(id: p.id, name: p.name))
            .toList();
        _updateState(contacts, failure);
        break;
      case UserRole.konselor:
        final (pasienList, failure) = await repo.getSortedPatientList();
        final filteredList = pasienList
            ?.where((p) => p.status == 'Pengguna Baru')
            .toList();
        final contacts = filteredList
            ?.map((p) => ChatContact(id: p.id, name: p.name))
            .toList();
        _updateState(contacts, failure);
        break;
      default:
        state = AsyncValue.data([]);
    }
  }

  Future<void> markAsRead(String contactId) async {
    await ref.read(chatRepositoryProvider).clearUnreadCount(contactId);

    state = state.whenData((contacts) {
      return [
        for (final contact in contacts)
          if (contact.id == contactId)
            contact.copyWith(unreadCount: 0)
          else
            contact,
      ];
    });
  }

  void _updateState(List<ChatContact>? contacts, Failure? failure) {
    if (failure != null) {
      state = AsyncValue.error(failure, StackTrace.current);
    } else {
      state = AsyncValue.data(contacts ?? []);
    }
  }
}

final chatListProvider =
    NotifierProvider<ChatListViewModel, AsyncValue<List<ChatContact>>>(
      () => ChatListViewModel(),
    );

final chatSearchQueryProvider = StateProvider<String>((ref) => '');

class ChatMessagesViewModel
    extends FamilyNotifier<AsyncValue<List<ChatMessage>>, String> {
  StreamSubscription? _subscription;

  @override
  AsyncValue<List<ChatMessage>> build(String contactId) {
    _listenForIncomingMessages();
    _fetchInitialMessages();
    ref.onDispose(() => _subscription?.cancel());
    return const AsyncValue.loading();
  }

  String? get _currentUserId => ref.read(authNotifierProvider).value?.id;

  ChatRepository get _repo => ref.read(chatRepositoryProvider);

  Future<void> _fetchInitialMessages() async {
    state = const AsyncValue.loading();
    final (localMessages, localFailure) = await _repo.getLocalMessageHistory(
      arg,
    );

    if (localMessages != null && localMessages.isNotEmpty) {
      state = AsyncValue.data(localMessages);
    } else if (localFailure != null) {
      state = AsyncValue.error(localFailure, StackTrace.current);
    }

    final (syncedMessages, remoteFailure) = await _repo.syncMessageHistory(arg);

    if (syncedMessages != null) {
      state = AsyncValue.data(syncedMessages);
    } else if (remoteFailure != null && state.value == null) {
      state = AsyncValue.error(remoteFailure, StackTrace.current);
    }
  }

  void _listenForIncomingMessages() {
    _subscription?.cancel();
    _subscription = _repo.incomingMessages.listen((message) {
      if (message.from == _currentUserId) return;
      if (message.from == arg) {
        final currentMessages = state.valueOrNull ?? [];
        if (!currentMessages.any((m) => m.messageId == message.messageId)) {
          state = AsyncValue.data([...currentMessages, message]);
        }
      } else {
        ref.invalidate(chatListProvider);
      }
    });
  }

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

    await _repo.sendMessage(message);
    ref.invalidate(chatListProvider);
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      ChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => ChatMessagesViewModel());
