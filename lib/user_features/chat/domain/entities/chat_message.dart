import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'chat_message.g.dart';

@HiveType(typeId: 2)
enum MessageType {
  @HiveField(0)
  sent,

  @HiveField(1)
  received,
}

class ChatMessage extends Equatable {
  final String messageId;
  final String from;
  final String to;
  final String text;
  final DateTime timestamp;
  final MessageType type;

  const ChatMessage({
    required this.messageId,
    required this.from,
    required this.to,
    required this.text,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object?> get props => [messageId, from, to, text, timestamp, type];
}

