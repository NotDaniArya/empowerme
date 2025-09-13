import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:new_empowerme/user_features/chat/domain/entities/chat_message.dart';

part 'chat_message_model.g.dart';

@HiveType(typeId: 1)
class ChatMessageModel extends HiveObject {
  @HiveField(0)
  final String messageId;

  @HiveField(1)
  final String from;

  @HiveField(2)
  final String to;

  @HiveField(3)
  final String text;

  @HiveField(4)
  final DateTime timestamp;

  @HiveField(5)
  final MessageType type;

  ChatMessageModel({
    required this.messageId,
    required this.from,
    required this.to,
    required this.text,
    required this.timestamp,
    required this.type,
  });

  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    final date = DateFormat('yyyy-MM-dd').parse(json['date']);
    final timeParts = (json['time'] as String).split(':');
    final time = DateTime(
      date.year,
      date.month,
      date.day,
      int.parse(timeParts[0]),
      int.parse(timeParts[1]),
      int.parse(timeParts[2]),
    );

    return ChatMessageModel(
      messageId: json['messageId'],
      from: json['from'],
      to: json['to'],
      text: json['text'],
      timestamp: time,
      type: json['from'] == currentUserId
          ? MessageType.sent
          : MessageType.received,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'messageId': messageId,
      'from': from,
      'to': to,
      'text': text,
      'date': DateFormat('yyyy-MM-dd').format(timestamp),
      'time': DateFormat('HH:mm:ss').format(timestamp),
      // --- PERBAIKAN DI SINI ---
      // Mengubah 'message' menjadi 'PRIVATE' agar sesuai dengan DTO backend
      'type': 'PRIVATE',
    };
  }

  ChatMessage toEntity() {
    return ChatMessage(
      messageId: messageId,
      from: from,
      to: to,
      text: text,
      timestamp: timestamp,
      type: type,
    );
  }
}
