import 'package:new_empowerme/pendamping_features/daftar_pasien/data/model/pasien_model.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/comment.dart';

class CommentModel extends Comment {
  const CommentModel({
    super.id,
    required super.comment,
    required super.like,
    required super.pasien,
    super.replyComment,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> repliesJson = json['replayComments'] ?? [];

    // Map setiap item menjadi objek ReplyCommentModel
    final List<ReplyComment> repliesList = repliesJson
        .map((reply) => ReplyCommentModel.fromJson(reply))
        .toList();

    return CommentModel(
      comment: json['comment'],
      like: json['like'],
      pasien: PasienModel.fromJson(json['user']),
      id: json['id'],
      replyComment: repliesList,
    );
  }
}

class ReplyCommentModel extends ReplyComment {
  const ReplyCommentModel({required super.pasien, required super.comment});

  factory ReplyCommentModel.fromJson(Map<String, dynamic> json) {
    return ReplyCommentModel(
      pasien: PasienModel.fromJson(json['user']),
      comment: json['comment'],
    );
  }
}
