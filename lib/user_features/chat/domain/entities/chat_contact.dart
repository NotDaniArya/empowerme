import 'package:equatable/equatable.dart';

class ChatContact extends Equatable {
  final String id;
  final String name;

  const ChatContact({required this.id, this.name = ''});

  @override
  List<Object?> get props => [id, name];
}
