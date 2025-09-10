import 'package:equatable/equatable.dart';

class Makanan extends Equatable {
  final String link;
  final String title;
  final String source;
  final String date;
  final String description;

  const Makanan({
    required this.link,
    required this.title,
    required this.source,
    required this.date,
    required this.description,
  });

  @override
  List<Object?> get props => [link, title, source, date, description];
}
