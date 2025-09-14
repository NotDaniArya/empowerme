import 'package:equatable/equatable.dart';

class ChatContact extends Equatable {
  final String id;
  final String name;
  final int unreadCount;

  const ChatContact({required this.id, this.name = '', this.unreadCount = 0});

  @override
  List<Object?> get props => [id, name, unreadCount];

  ChatContact copyWith({String? id, String? name, int? unreadCount}) {
    return ChatContact(
      id: id ?? this.id,
      name: name ?? this.name,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
