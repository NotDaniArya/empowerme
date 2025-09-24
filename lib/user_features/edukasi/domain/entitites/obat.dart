import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Obat extends Equatable {
  final String link;
  final String title;
  final String source;
  final String date;
  final String description;

  const Obat({
    required this.link,
    required this.title,
    required this.source,
    required this.date,
    required this.description,
  });

  String get formattedPublishedAt {
    if (date.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final dateTime = DateTime.parse(date);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return date;
    }
  }

  @override
  List<Object?> get props => [link, title, source, date, description];
}
