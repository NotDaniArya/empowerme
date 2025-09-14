import 'package:hive_flutter/hive_flutter.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_contact.dart';

import '../../../auth/data/datasources/auth_local_datasource.dart';
import '../models/chat_message_model.dart';

abstract class ChatLocalDataSource {
  Future<void> saveMessage(ChatMessageModel message);

  Future<List<ChatMessageModel>> getMessageHistory(String contactId);

  Future<void> saveContacts(List<ChatContact> contacts);

  Future<List<ChatContact>> getContacts();

  Future<void> updateContactActivity(String contactId);

  Future<Map<String, int>> getAllContactActivities();

  Future<void> incrementUnreadCount(String contactId);

  Future<void> clearUnreadCount(String contactId);

  Future<Map<String, int>> getAllUnreadCounts();
}

class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final AuthLocalDataSource authLocalDataSource;

  const ChatLocalDataSourceImpl({required this.authLocalDataSource});

  final String _contactsBoxName = 'chat_contacts';
  final String _activityBoxName = 'chat_activity';
  final String _unreadCountBoxName = 'chat_unread_count';

  String _chatBoxName(String contactId) => 'chat_with_$contactId';

  @override
  Future<void> saveMessage(ChatMessageModel message) async {
    final currentUserId = await authLocalDataSource.getId();
    if (currentUserId == null) return;

    final contactId = message.from == currentUserId ? message.to : message.from;
    final box = await Hive.openBox<ChatMessageModel>(_chatBoxName(contactId));
    await box.put(message.messageId, message);
  }

  @override
  Future<List<ChatMessageModel>> getMessageHistory(String contactId) async {
    final box = await Hive.openBox<ChatMessageModel>(_chatBoxName(contactId));
    final messages = box.values.toList();
    messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    return messages;
  }

  @override
  Future<List<ChatContact>> getContacts() async {
    final contactsBox = await Hive.openBox<String>(_contactsBoxName);
    final unreadBox = await Hive.openBox<int>(_unreadCountBoxName);

    final List<ChatContact> contacts = [];
    for (var key in contactsBox.keys) {
      contacts.add(
        ChatContact(
          id: key as String,
          name: contactsBox.get(key)!,
          unreadCount: unreadBox.get(key) ?? 0,
        ),
      );
    }
    return contacts;
  }

  @override
  Future<void> saveContacts(List<ChatContact> contacts) async {
    final box = await Hive.openBox<String>(_contactsBoxName);
    await box.clear();
    final contactsMap = {for (var c in contacts) c.id: c.name};
    await box.putAll(contactsMap);
  }

  @override
  Future<void> updateContactActivity(String contactId) async {
    final box = await Hive.openBox<int>(_activityBoxName);
    await box.put(contactId, DateTime.now().millisecondsSinceEpoch);
  }

  @override
  Future<Map<String, int>> getAllContactActivities() async {
    final box = await Hive.openBox<int>(_activityBoxName);
    return box.toMap().cast<String, int>();
  }

  @override
  Future<void> incrementUnreadCount(String contactId) async {
    final box = await Hive.openBox<int>(_unreadCountBoxName);
    final currentCount = box.get(contactId) ?? 0;
    await box.put(contactId, currentCount + 1);
  }

  @override
  Future<void> clearUnreadCount(String contactId) async {
    final box = await Hive.openBox<int>(_unreadCountBoxName);
    await box.put(contactId, 0);
  }

  @override
  Future<Map<String, int>> getAllUnreadCounts() async {
    final box = await Hive.openBox<int>(_unreadCountBoxName);
    return box.toMap().cast<String, int>();
  }
}
