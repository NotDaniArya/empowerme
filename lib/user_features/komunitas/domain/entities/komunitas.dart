import 'package:equatable/equatable.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

import 'comment.dart';

class Komunitas extends Equatable {
  final String id;
  final String content;
  final DateTime createdAt;
  final int like;
  final bool statusLike;
  final int countComment;
  final List<Comment>? comments;
  final Pasien? pasien;

  const Komunitas({
    required this.id,
    required this.content,
    required this.createdAt,
    required this.like,
    required this.statusLike,
    required this.countComment,
    this.pasien,
    this.comments,
  });

  Komunitas copyWith({
    String? id,
    String? content,
    DateTime? createdAt,
    int? like,
    bool? statusLike,
    int? countComment,
    Pasien? pasien,
    List<Comment>? comments,
  }) {
    return Komunitas(
      id: id ?? this.id,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
      like: like ?? this.like,
      statusLike: statusLike ?? this.statusLike,
      countComment: countComment ?? this.countComment,
      pasien: pasien ?? this.pasien,
      comments: comments ?? this.comments,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    content,
    createdAt,
    like,
    statusLike,
    countComment,
    pasien,
  ];
}
