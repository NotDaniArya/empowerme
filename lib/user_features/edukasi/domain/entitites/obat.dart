import 'package:equatable/equatable.dart';

class Obat extends Equatable {
  final String link;
  final String title;
  final String source;
  final String date;
  final String description;
  final String thumbnail;

  const Obat({
    required this.link,
    required this.title,
    required this.source,
    required this.date,
    required this.description,
    required this.thumbnail,
  });

  String get displayImageUrl {
    const String placeholder =
        'https://mobeng.id/wp-content/uploads/2021/10/placeholder-1-1.png';
    if (thumbnail.isNotEmpty) {
      return thumbnail;
    }
    return placeholder;
  }

  @override
  List<Object?> get props => [
    link,
    title,
    source,
    date,
    description,
    thumbnail,
  ];
}
