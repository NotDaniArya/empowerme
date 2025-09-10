import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';

class ObatModel extends Obat {
  const ObatModel({
    required super.link,
    required super.title,
    required super.source,
    required super.date,
    required super.description,
  });

  factory ObatModel.fromJson(Map<String, dynamic> json) {
    return ObatModel(
      link: json['link'],
      title: json['title'],
      source: json['source'],
      date: json['date'],
      description: json['snippet'],
    );
  }
}
