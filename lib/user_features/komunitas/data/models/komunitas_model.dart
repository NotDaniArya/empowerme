import 'package:new_empowerme/pendamping_features/daftar_pasien/data/model/pasien_model.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/comment_model.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';

import '../../domain/entities/comment.dart';

class KomunitasModel extends Komunitas {
  const KomunitasModel({
    required super.id,
    required super.content,
    required super.title,
    required super.createdAt,
    required super.like,
    required super.share,
    required super.pasien,
    super.comments,
  });

  factory KomunitasModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> commentsJson = json['comments'] ?? [];

    final List<Comment> commentsList = commentsJson
        .map((comment) => CommentModel.fromJson(comment))
        .toList();

    return KomunitasModel(
      id: json['id'],
      content: json['content'],
      title: json['title'],
      createdAt: DateTime.parse(json['createdAt']),
      like: json['like'],
      share: json['share'],
      pasien: PasienModel.fromJson(json['user']),
      comments: commentsList,
    );
  }
}
