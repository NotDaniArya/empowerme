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

  // --- FUNGSI BARU UNTUK MENAMBAHKAN KONTAK DEFAULT ---
  List<ChatContact> _addDefaultContacts(List<ChatContact> existingContacts) {
    final contactSet = {for (var contact in existingContacts) contact.id};
    final updatedContacts = List<ChatContact>.from(existingContacts);

    // Definisikan kontak default
    const pendamping = ChatContact(id: '000005', name: 'Pendamping');
    const konselor = ChatContact(id: '000006', name: 'Konselor');

    // Tambahkan Konselor ke awal daftar jika belum ada
    if (!contactSet.contains(konselor.id)) {
      updatedContacts.insert(0, konselor);
    }

    // Tambahkan Pendamping ke awal daftar jika belum ada
    if (!contactSet.contains(pendamping.id)) {
      updatedContacts.insert(0, pendamping);
    }

    return updatedContacts;
  }

  @override
  Future<(List<ChatContact>?, Failure?)> getChatContacts() async {
    final userId = _currentUserId;
    if (userId == null) {
      return (null, const Failure('Sesi pengguna tidak valid.'));
    }

    try {
      // 1. Ambil daftar kontak dari server
      final remoteContacts = await remoteDataSource.getChatContacts(userId);
      // 2. Tambahkan kontak default ke daftar tersebut
      final allContacts = _addDefaultContacts(remoteContacts);
      // 3. Simpan daftar yang sudah lengkap ke database lokal
      await localDataSource.saveContacts(allContacts);
      return (allContacts, null);
    } on Failure catch (f) {
      // Jika server gagal, ambil dari lokal dan pastikan kontak default tetap ada
      final localContacts = await localDataSource.getContacts();
      final allContacts = _addDefaultContacts(localContacts);
      return (allContacts, f);
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
