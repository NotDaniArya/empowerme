import 'package:new_empowerme/user_features/edukasi/domain/entitites/makanan.dart';

class MakananModel extends Makanan {
  const MakananModel({
    required super.link,
    required super.title,
    required super.source,
    required super.date,
    required super.description,
    required super.thumbnail,
  });

  factory MakananModel.fromJson(Map<String, dynamic> json) {
    return MakananModel(
      link: json['link'],
      title: json['title'],
      source: json['source'],
      date: json['date'],
      description: json['snippet'],
      thumbnail: json['thumbnail'],
    );
  }
}
