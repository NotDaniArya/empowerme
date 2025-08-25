import 'package:equatable/equatable.dart';
import 'package:new_empowerme/pendamping_features/daftar_pasien/domain/entities/pasien.dart';

class Comment extends Equatable {
  final String? id;
  final String comment;
  final int like;
  final Pasien pasien;
  final List<ReplyComment>? replyComment;

  const Comment({
    this.id,
    required this.comment,
    required this.like,
    required this.pasien,
    this.replyComment,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id, comment, like, pasien, replyComment];
}

class ReplyComment extends Equatable {
  final Pasien pasien;
  final String comment;

  const ReplyComment({required this.pasien, required this.comment});

  @override
  // TODO: implement props
  List<Object?> get props => [pasien, comment];
}
