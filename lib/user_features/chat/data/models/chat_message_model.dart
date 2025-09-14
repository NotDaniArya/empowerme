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
    DateTime parsedTimestamp;
    try {
      final dateString = json['date'] as String? ?? '';
      final timeString = json['time'] as String? ?? '';

      if (dateString.isNotEmpty && timeString.isNotEmpty) {
        final fullDateTimeString = '$dateString $timeString';
        parsedTimestamp = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).parse(fullDateTimeString);
      } else {
        parsedTimestamp = DateTime.now();
      }
    } catch (e) {
      print('Error parsing timestamp from JSON: $json. Error: $e');
      parsedTimestamp = DateTime.now();
    }

    return ChatMessageModel(
      messageId: json['messageId'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      text: json['text'] as String? ?? '',
      timestamp: parsedTimestamp,
      type: (json['from'] as String? ?? '') == currentUserId
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
