import 'package:new_empowerme/user_features/edukasi/domain/entitites/berita.dart';

class BeritaModel extends Berita {
  const BeritaModel({
    required super.title,
    required super.author,
    required super.urlToImage,
    required super.publishedAt,
    required super.description,
    required super.url,
  });

  factory BeritaModel.fromJson(Map<String, dynamic> json) {
    return BeritaModel(
      title: json['title'],
      author: json['author'],
      urlToImage: json['urlToImage'],
      publishedAt: json['publishedAt'],
      description: json['description'],
      url: json['url'],
    );
  }
}
