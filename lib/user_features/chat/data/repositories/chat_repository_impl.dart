import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';

import '../../domain/entities/chat_contact.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_local_datasource.dart';
import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final Ref ref;

  String? get _currentUserId => ref.read(authNotifierProvider).valueOrNull?.id;

  ChatRepositoryImpl(this.remoteDataSource, this.localDataSource, this.ref);

  @override
  Stream<ChatMessage> get incomingMessages =>
      remoteDataSource.incomingMessages.asyncMap((messageModel) async {
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
  Future<(List<ChatContact>?, Failure?)> getChatContacts() async {
    final userId = _currentUserId;
    if (userId == null) {
      return (null, const Failure('Sesi pengguna tidak valid.'));
    }
    try {
      final remoteContacts = await remoteDataSource.getChatContacts(userId);
      await localDataSource.saveContacts(remoteContacts);
      return (remoteContacts, null);
    } on Failure catch (f) {
      final localContacts = await localDataSource.getContacts();
      return (localContacts, f);
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
    if (userId == null)
      return (null, const Failure('Sesi pengguna tidak valid.'));

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
      final messageModel = ChatMessageModel(
        messageId: message.messageId,
        from: message.from,
        to: message.to,
        text: message.text,
        timestamp: message.timestamp,
        type: message.type,
      );
      await localDataSource.saveMessage(messageModel);
      await remoteDataSource.sendMessage(messageModel);
      return (null, null);
    } on Failure catch (f) {
      return (null, f);
    }
  }
}
