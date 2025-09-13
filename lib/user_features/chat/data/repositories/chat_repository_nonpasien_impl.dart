import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/chat/data/datasources/chat_local_datasource.dart';
import 'package:new_empowerme/user_features/chat/data/datasources/chat_remote_datasource.dart';
import 'package:new_empowerme/user_features/chat/data/models/chat_message_model.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';
import 'package:new_empowerme/user_features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryNonPasienImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final Ref ref;

  // Menggunakan getter yang aman untuk mengambil ID pengguna saat ini
  String? get _currentUserId => ref.read(authNotifierProvider).valueOrNull?.id;

  ChatRepositoryNonPasienImpl(
    this.remoteDataSource,
    this.localDataSource,
    this.ref,
  );

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
    // Menambahkan pemeriksaan keamanan untuk memastikan ID pengguna ada
    final userId = _currentUserId;
    if (userId == null) {
      return (null, const Failure('Sesi pengguna tidak valid.'));
    }

    try {
      // Ambil kontak dari remote (sudah sesuai dengan endpoint /list/{userId})
      final contacts = await remoteDataSource.getChatContacts(userId);
      await localDataSource.saveContacts(contacts);
      return (contacts, null);
    } on Failure catch (f) {
      // Jika remote gagal, ambil dari lokal sebagai fallback
      final localContacts = await localDataSource.getContacts();
      return (localContacts, f);
    }
  }

  @override
  Future<(List<ChatMessage>?, Failure?)> getMessageHistory(
    String contactId,
  ) async {
    final userId = _currentUserId;
    if (userId == null) {
      return (null, const Failure('Sesi pengguna tidak valid.'));
    }

    try {
      // Ambil riwayat dari remote (sudah sesuai dengan endpoint /chat/{userId}/{contactId})
      final remoteHistoryModels = await remoteDataSource.getMessageHistory(
        userId,
        contactId,
      );
      for (var msgModel in remoteHistoryModels) {
        await localDataSource.saveMessage(msgModel);
      }
      final remoteHistoryEntities = remoteHistoryModels
          .map((model) => model.toEntity())
          .toList();
      return (remoteHistoryEntities, null);
    } on Failure catch (f) {
      final localHistoryModels = await localDataSource.getMessageHistory(
        contactId,
      );
      final localHistoryEntities = localHistoryModels
          .map((model) => model.toEntity())
          .toList();
      return (localHistoryEntities, f);
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
