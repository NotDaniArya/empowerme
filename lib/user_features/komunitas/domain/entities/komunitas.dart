import 'package:equatable/equatable.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

import 'comment.dart';

class Komunitas extends Equatable {
  final String id;
  final String content;
  final String title;
  final DateTime createdAt;
  final int like;
  final int share;
  final int countComment;
  final List<Comment>? comments;
  final Pasien? pasien;

  const Komunitas({
    required this.id,
    required this.content,
    required this.title,
    required this.createdAt,
    required this.like,
    required this.share,
    required this.countComment,
    this.pasien,
    this.comments,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    content,
    title,
    createdAt,
    like,
    share,
    countComment,
    pasien,
  ];
}
