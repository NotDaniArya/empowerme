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

  // ===================================================================
  // FACTORY CONSTRUCTOR YANG TELAH DIPERBAIKI SECARA TOTAL
  // ===================================================================
  factory ChatMessageModel.fromJson(
    Map<String, dynamic> json,
    String currentUserId,
  ) {
    DateTime parsedTimestamp;
    try {
      // 1. Ambil string tanggal dan waktu dengan aman, berikan default jika null
      final dateString = json['date'] as String? ?? '';
      final timeString = json['time'] as String? ?? '';

      if (dateString.isNotEmpty && timeString.isNotEmpty) {
        // Gabungkan string tanggal dan waktu untuk parsing yang lebih andal
        final fullDateTimeString = '$dateString $timeString';
        // Gunakan format yang sesuai untuk mem-parsing gabungan string
        parsedTimestamp = DateFormat(
          'yyyy-MM-dd HH:mm:ss',
        ).parse(fullDateTimeString);
      } else {
        // Jika data tanggal/waktu tidak ada, gunakan waktu saat ini sebagai fallback
        parsedTimestamp = DateTime.now();
      }
    } catch (e) {
      // Jika parsing gagal karena format tidak terduga, gunakan waktu saat ini
      print('Error parsing timestamp from JSON: $json. Error: $e');
      parsedTimestamp = DateTime.now();
    }

    return ChatMessageModel(
      // 2. Berikan nilai default yang aman untuk setiap field
      messageId: json['messageId'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      text: json['text'] as String? ?? '',
      timestamp: parsedTimestamp,
      // Tentukan tipe pesan berdasarkan pengirim
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
