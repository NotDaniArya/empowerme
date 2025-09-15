import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';

import '../../../../pendamping_features/daftar_pasien/domain/entities/pasien.dart';
import '../../../../pendamping_features/daftar_pasien/domain/repositories/pasien_repository.dart';
import '../../domain/entities/chat_contact.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final PasienRepository pasienRepository;
  final Ref ref;

  String? get _currentUserId => ref.read(authNotifierProvider).valueOrNull?.id;

  ChatRepositoryImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.pasienRepository,
    this.ref,
  );

  @override
  Stream<ChatMessage> get incomingMessages =>
      remoteDataSource.incomingMessages.asyncMap((messageModel) async {
        await localDataSource.incrementUnreadCount(messageModel.from);
        await localDataSource.updateContactActivity(messageModel.from);
        await localDataSource.saveMessage(messageModel);
        return messageModel.toEntity();
      });

  @override
  Future<(void, Failure?)> connect(String userId) async {
    try {
      await remoteDataSource.connect(userId);
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    }
  }

  @override
  void disconnect() {
    remoteDataSource.disconnect();
  }

  @override
  Future<(void, Failure?)> clearUnreadCount(String contactId) async {
    try {
      await localDataSource.clearUnreadCount(contactId);
      return (null, null);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<ChatContact>?, Failure?)> getPasienChatContacts() async {
    try {
      const pendamping = ChatContact(id: '000005', name: 'Pendamping');
      const konselor = ChatContact(id: '000006', name: 'Konselor');

      final activityData = await localDataSource.getAllContactActivities();
      final unreadData = await localDataSource.getAllUnreadCounts();

      final defaultContacts = [pendamping, konselor];

      var contactsWithData = defaultContacts.map((c) {
        return c.copyWith(unreadCount: unreadData[c.id] ?? 0);
      }).toList();

      contactsWithData.sort((a, b) {
        final activityA = activityData[a.id] ?? 0;
        final activityB = activityData[b.id] ?? 0;
        return activityB.compareTo(activityA);
      });

      return (contactsWithData, null);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<Pasien>?, Failure?)> getSortedPatientList() async {
    try {
      final (pasienList, failure) = await pasienRepository.getAllPasien();
      if (failure != null) {
        return (null, failure);
      }

      final activityData = await localDataSource.getAllContactActivities();

      final validPasienList = pasienList ?? [];
      validPasienList.sort((a, b) {
        final activityA = activityData[a.id] ?? 0;
        final activityB = activityData[b.id] ?? 0;
        return activityB.compareTo(activityA);
      });

      return (validPasienList, null);
    } catch (e) {
      return (null, Failure(e.toString()));
    }
  }

  @override
  Future<(List<ChatMessage>?, Failure?)> getLocalMessageHistory(
    String contactId,
  ) async {
    try {
      final localHistoryModels = await localDataSource.getMessageHistory(
        contactId,
      );
      final localHistoryEntities = localHistoryModels
          .map((model) => model.toEntity())
          .toList();
      return (localHistoryEntities, null);
    } catch (e) {
      return (
        null,
        Failure(
          'Gagal memuat riwayat chat dari penyimpanan lokal: ${e.toString()}',
        ),
      );
    }
  }

  @override
  Future<(List<ChatMessage>?, Failure?)> syncMessageHistory(
    String contactId,
  ) async {
    final userId = _currentUserId;
    if (userId == null) {
      return (null, const Failure('Sesi pengguna tidak valid.'));
    }

    try {
      final remoteHistoryModels = await remoteDataSource.getMessageHistory(
        userId,
        contactId,
      );
      for (var msgModel in remoteHistoryModels) {
        await localDataSource.saveMessage(msgModel);
      }
      return await getLocalMessageHistory(contactId);
    } on Failure catch (f) {
      final (localMessages, _) = await getLocalMessageHistory(contactId);
      return (localMessages, f);
    }
  }

  @override
  Future<(void, Failure?)> sendMessage(ChatMessage message) async {
    try {
      final messageModel = ChatMessageModel.fromEntity(message);
      await localDataSource.updateContactActivity(message.to);
      await localDataSource.saveMessage(messageModel);
      await remoteDataSource.sendMessage(messageModel);
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    }
  }
}
