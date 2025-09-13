import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';

import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> saveMessage(ChatMessageModel message);
  Future<List<ChatMessageModel>> getMessageHistory(String contactId);
  Future<void> saveContacts(List<ChatContact> contacts);
  Future<List<ChatContact>> getContacts();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
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
    final contactId = message.from == 'me'
        ? message.to
        : message.from; // Ganti 'me' dengan ID user
    final box = await _getChatBox(contactId);
    await box.put(message.messageId, message);
  }

  @override
  Future<List<ChatMessageModel>> getMessageHistory(String contactId) async {
    final box = await _getChatBox(contactId);
    return box.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
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
    for (var contact in contacts) {
      await box.put(contact.id, contact.id);
    }
  }
}
