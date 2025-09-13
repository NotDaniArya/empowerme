import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/auth/presentation/providers/auth_provider.dart';
import 'package:new_empowerme/user_features/chat/data/datasources/chat_local_datasource.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';
import 'package:new_empowerme/user_features/chat/domain/repositories/chat_repository.dart';

import '../datasources/chat_remote_datasource.dart';
import '../models/chat_message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;
  final ChatLocalDataSource localDataSource;
  final Ref ref;

  String? get _currentUserId => ref.read(authNotifierProvider).value?.id;

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

  // --- LOGIKA BARU UNTUK MENAMBAHKAN KONTAK DEFAULT ---
  List<ChatContact> _addDefaultContacts(List<ChatContact> existingContacts) {
    // Gunakan Set untuk efisiensi dan menghindari duplikat
    final contactSet = {for (var contact in existingContacts) contact.id};
    final updatedContacts = List<ChatContact>.from(existingContacts);

    // CATATAN: Di aplikasi nyata, ID ini sebaiknya didapatkan secara dinamis
    // dari profil pengguna atau dari endpoint API khusus.
    const pendampingId =
        'pendamping_user_id'; // Ganti dengan ID Pendamping yang sebenarnya
    const konselorId =
        'konselor_user_id'; // Ganti dengan ID Konselor yang sebenarnya

    // Tambahkan Konselor jika belum ada di daftar
    if (!contactSet.contains(konselorId)) {
      updatedContacts.insert(
        0,
        const ChatContact(id: konselorId, name: 'Konselor'),
      );
    }

    // Tambahkan Pendamping jika belum ada di daftar
    if (!contactSet.contains(pendampingId)) {
      updatedContacts.insert(
        0,
        const ChatContact(id: pendampingId, name: 'Pendamping'),
      );
    }

    return updatedContacts;
  }

  // --- FUNGSI getChatContacts YANG TELAH DIPERBARUI ---
  @override
  Future<(List<ChatContact>?, Failure?)> getChatContacts() async {
    try {
      if (_currentUserId == null) {
        return (null, const Failure('User ID tidak ditemukan.'));
      }
      // 1. Ambil kontak yang sudah ada dari remote
      final remoteContacts = await remoteDataSource.getChatContacts(
        _currentUserId!,
      );

      // 2. Tambahkan kontak default (Pendamping & Konselor)
      final allContacts = _addDefaultContacts(remoteContacts);

      // 3. Simpan daftar lengkap ke penyimpanan lokal
      await localDataSource.saveContacts(allContacts);

      return (allContacts, null);
    } on Failure catch (f) {
      // Jika remote gagal, ambil dari lokal dan tetap pastikan kontak default ada
      final localContacts = await localDataSource.getContacts();
      final allContacts = _addDefaultContacts(localContacts);

      return (allContacts, f);
    }
  }

  @override
  Future<(List<ChatMessage>?, Failure?)> getMessageHistory(
    String contactId,
  ) async {
    try {
      final remoteHistoryModels = await remoteDataSource.getMessageHistory(
        _currentUserId!,
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
