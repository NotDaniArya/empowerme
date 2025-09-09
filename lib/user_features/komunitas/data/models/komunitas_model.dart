import 'package:new_empowerme/pendamping_features/daftar_pasien/data/model/pasien_model.dart';
import 'package:new_empowerme/user_features/komunitas/data/models/comment_model.dart';
import 'package:new_empowerme/user_features/komunitas/domain/entities/komunitas.dart';

import '../../domain/entities/comment.dart';

class KomunitasModel extends Komunitas {
  const KomunitasModel({
    required super.id,
    required super.content,
    required super.createdAt,
    required super.like,
    required super.statusLike,
    required super.countComment,
    required super.pasien,
    super.comments,
  });

  factory KomunitasModel.fromJson(Map<String, dynamic> json) {
    // Ambil list 'comments' dari JSON
    final List<dynamic> commentsJson = json['comments'] ?? [];

    // Map setiap item di list menjadi objek CommentModel
    final List<Comment> commentsList = commentsJson
        .map((comment) => CommentModel.fromJson(comment))
        .toList();

    return KomunitasModel(
      id: json['id'],
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
      like: json['like'],
      statusLike: json['statusLike'],
      countComment: json['countComment'],
      pasien: PasienModel.fromJson(json['user']),
      comments: commentsList, // Berikan list yang sudah di-parsing
    );
  }
}
