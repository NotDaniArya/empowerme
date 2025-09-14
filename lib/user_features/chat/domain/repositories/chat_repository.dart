import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';

import '../../../../core/failure.dart';

abstract class ChatRepository {
  Future<(void, Failure?)> connect(String userId);

  void disconnect();

  Stream<ChatMessage> get incomingMessages;

  Future<(void, Failure?)> sendMessage(ChatMessage message);

  /// Mengambil riwayat dari remote dan menyimpannya ke lokal (fungsi sinkronisasi).
  Future<(List<ChatMessage>?, Failure?)> syncMessageHistory(String contactId);

  /// BARU: Mengambil riwayat pesan HANYA dari database lokal.
  Future<(List<ChatMessage>?, Failure?)> getLocalMessageHistory(
    String contactId,
  );

  Future<(List<ChatContact>?, Failure?)> getChatContacts();

  // Future<(List<ChatContact>?, Failure?)> getNonPasienChatContacts();
}
