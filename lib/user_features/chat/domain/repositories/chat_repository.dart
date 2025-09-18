import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';

import '../../../../core/failure.dart';

abstract class ChatRepository {
  Future<(void, Failure?)> connect(String userId);

  void disconnect();

  Stream<ChatMessage> get incomingMessages;

  Future<(void, Failure?)> sendMessage(ChatMessage message);

  Future<(List<ChatMessage>?, Failure?)> getLocalMessageHistory(
    String contactId,
  );

  Future<(List<ChatMessage>?, Failure?)> syncMessageHistory(String contactId);

  Future<(List<ChatContact>?, Failure?)> getPasienChatContacts();

  Future<(List<ChatContact>?, Failure?)> getSortedPatientList();

  Future<(void, Failure?)> clearUnreadCount(String contactId);
}
