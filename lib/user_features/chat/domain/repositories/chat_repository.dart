import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';

import '../../../../core/failure.dart';

abstract class ChatRepository {
  // Koneksi WebSocket
  Future<(void, Failure?)> connect(String userId);

  void disconnect();

  Stream<ChatMessage> get incomingMessages;

  // Operasi Chat
  Future<(void, Failure?)> sendMessage(ChatMessage message);

  Future<(List<ChatMessage>?, Failure?)> getMessageHistory(String contactId);

  Future<(List<ChatContact>?, Failure?)> getChatContacts();
}
