import 'package:equatable/equatable.dart';

class ChatContact extends Equatable {
  final String id;
  final String name; // Anda mungkin perlu mengambil nama dari user ID
  // Tambahkan properti lain jika perlu, seperti lastMessage, unreadCount, dll.

  const ChatContact({
    required this.id,
    this.name = '', // Default ke ID jika nama tidak diketahui
  });

  @override
  List<Object?> get props => [id, name];
}
