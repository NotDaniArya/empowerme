import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';

import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> saveMessage(ChatMessageModel message);

  Future<List<ChatMessageModel>> getMessageHistory(String contactId);

  Future<void> saveContacts(List<ChatContact> contacts);

  Future<List<ChatContact>> getContacts();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AuthLocalDataSource authLocalDataSource;

  const ChatLocalDataSourceImpl({required this.authLocalDataSource});

  Future<Box<ChatMessageModel>> _getChatBox(String contactId) async {
    final boxName = 'chat_${contactId.replaceAll('-', '_')}';
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<ChatMessageModel>(boxName);
    }
    return await Hive.openBox<ChatMessageModel>(boxName);
  }

  Future<Box<String>> _getContactsBox() async {
    const boxName = 'chat_contacts';
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<String>(boxName);
    }
    return await Hive.openBox<String>(boxName);
  }

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    final currentUserId = await authLocalDataSource.getId();

    final contactId = message.from == currentUserId ? message.to : message.from;
    final box = await _getChatBox(contactId);
    await box.put(message.messageId, message);
  }

  @override
  Future<List<ChatMessageModel>> getMessageHistory(String contactId) async {
    final box = await _getChatBox(contactId);
    final messages = box.values.toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<List<ChatContact>> getContacts() async {
    final box = await _getContactsBox();
    return box.values.map((id) => ChatContact(id: id, name: id)).toList();
  }

  @override
  Future<void> saveContacts(List<ChatContact> contacts) async {
    final box = await _getContactsBox();
    await box.clear();
    final contactsMap = {for (var c in contacts) c.id: c.id};
    await box.putAll(contactsMap);
  }
}
