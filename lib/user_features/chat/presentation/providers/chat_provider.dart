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

class ChatMessagesViewModel
    extends FamilyNotifier<AsyncValue<List<ChatMessage>>, String> {
  StreamSubscription? _subscription;

  @override
  AsyncValue<List<ChatMessage>> build(String contactId) {
    _listenForIncomingMessages();

    _fetchInitialMessages();

    ref.onDispose(() {
      _subscription?.cancel();
    });

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
    }

    if (localFailure != null) {
      state = AsyncValue.error(localFailure, StackTrace.current);
    }

    final (syncedMessages, remoteFailure) = await _repo.syncMessageHistory(arg);

    if (syncedMessages != null) {
      state = AsyncValue.data(syncedMessages);
    }

    if (remoteFailure != null && syncedMessages == null) {
      state = AsyncValue.error(remoteFailure, StackTrace.current);
    }
  }

  void _listenForIncomingMessages() {
    _subscription?.cancel();
    _subscription = _repo.incomingMessages.listen((message) {
      if (message.from == arg) {
        final currentMessages = state.valueOrNull ?? [];
        if (!currentMessages.any((m) => m.messageId == message.messageId)) {
          state = AsyncValue.data([...currentMessages, message]);
        }
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
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      ChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => ChatMessagesViewModel());
