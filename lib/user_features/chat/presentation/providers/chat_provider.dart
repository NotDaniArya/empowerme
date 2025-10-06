import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/user_features/profile/presentation/providers/profile_provider.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/failure.dart';
import '../../../../pendamping_features/daftar_pasien/domain/entities/pasien.dart';
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
  ref.onDispose(() => chatRepository.disconnect());
  return chatRepository;
});

class ChatListViewModel extends Notifier<AsyncValue<List<ChatContact>>> {
  StreamSubscription? _messageSubscription;

  @override
  AsyncValue<List<ChatContact>> build() {
    final chatRepo = ref.watch(chatServiceProvider);

    _listenForIncomingMessages(chatRepo);

    _fetchContacts();

    ref.onDispose(() => _messageSubscription?.cancel());

    return const AsyncValue.loading();
  }

  void _listenForIncomingMessages(ChatRepository repo) {
    _messageSubscription?.cancel();
    _messageSubscription = repo.incomingMessages.listen((newMessage) {
      _onNewMessage(newMessage);
    });
  }

  void _onNewMessage(ChatMessage message) {
    final currentState = state.valueOrNull;
    if (currentState == null) return;

    final contactId = message.from;
    final contactIndex = currentState.indexWhere((c) => c.id == contactId);

    if (contactIndex != -1) {
      final contactToUpdate = currentState[contactIndex];
      final updatedContact = contactToUpdate.copyWith(
        unreadCount: contactToUpdate.unreadCount + 1,
      );

      final newList = List<ChatContact>.from(currentState);
      newList[contactIndex] = updatedContact;

      newList.sort(
        (a, b) =>
            (b.id == contactId ? 1 : 0).compareTo(a.id == contactId ? 1 : 0),
      );

      state = AsyncValue.data(newList);
    } else {
      _fetchContacts();
    }
  }

  Future<void> _fetchContacts() async {
    final userRole =
        ref.read(authNotifierProvider).valueOrNull?.role ?? UserRole.unknown;
    final profile = ref.read(profileViewModel).profile;

    state = const AsyncValue.loading();
    final repo = ref.read(chatRepositoryProvider);

    switch (userRole) {
      case UserRole.pasien:
        var (contacts, failure) = await repo.getPasienChatContacts();
        if (profile?.status == 'PENGGUNA LAMA') {
          contacts = contacts?.where((c) => c.id != '000006').toList();
        }
        _updateState(contacts, failure);
        break;
      case UserRole.pendamping:
        final (contacts, failure) = await repo.getSortedPatientList();
        _updateState(contacts, failure);
        break;
      case UserRole.konselor:
        final (pasienList, failure) = await ref
            .read(pasienRepositoryProvider)
            .getAllPasien();
        if (failure != null) {
          _updateState(null, failure);
          return;
        }
        final filteredPasien = pasienList
            ?.where((p) => p.status == 'PENGGUNA BARU')
            .toList();
        final contacts = await _getSortedContactsFromPasienList(
          filteredPasien ?? [],
        );
        _updateState(contacts, null);
        break;
      default:
        state = const AsyncValue.data([]);
    }
  }

  Future<List<ChatContact>> _getSortedContactsFromPasienList(
    List<Pasien> pasienList,
  ) async {
    final activityData = await ref
        .read(chatLocalDataSourceProvider)
        .getAllContactActivities();
    final unreadData = await ref
        .read(chatLocalDataSourceProvider)
        .getAllUnreadCounts();
    final contactList = pasienList.map((pasien) {
      return ChatContact(
        id: pasien.id,
        name: pasien.name,
        unreadCount: unreadData[pasien.id] ?? 0,
      );
    }).toList();
    contactList.sort((a, b) {
      final activityA = activityData[a.id] ?? 0;
      final activityB = activityData[b.id] ?? 0;
      return activityB.compareTo(activityA);
    });
    return contactList;
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
    await _repo.syncMessageHistory(arg);
    final (localMessages, localFailure) = await _repo.getLocalMessageHistory(
      arg,
    );
    if (localFailure != null) {
      state = AsyncValue.error(localFailure, StackTrace.current);
    } else {
      state = AsyncValue.data(localMessages ?? []);
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

  Future<void> refreshMessages() async {
    await _fetchInitialMessages();
  }
}

final chatMessagesProvider =
    NotifierProvider.family<
      ChatMessagesViewModel,
      AsyncValue<List<ChatMessage>>,
      String
    >(() => ChatMessagesViewModel());
