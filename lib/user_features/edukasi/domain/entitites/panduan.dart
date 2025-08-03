import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Panduan extends Equatable {
  final String id;
  final String title;
  final String publishedDate;
  final String description;
  final List<String> authors;
  final String publisher;
  final String thumbnail;
  final String infoLink;

  const Panduan({
    required this.id,
    required this.title,
    required this.publishedDate,
    required this.description,
    required this.authors,
    required this.publisher,
    required this.thumbnail,
    required this.infoLink,
  });

  // getter untuk mengecek apakah thumbnail null atau empty
  String get displayThumbnail {
    // placeholder jika tidak ada gambar
    const String placeholder =
        'https://mobeng.id/wp-content/uploads/2021/10/placeholder-1-1.png';
    if (thumbnail.isNotEmpty) {
      return thumbnail;
    }
    return placeholder;
  }

  String get formattedPublishedAt {
    if (publishedDate.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final dateTime = DateTime.parse(publishedDate);
      return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return publishedDate;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    id,
    title,
    publishedDate,
    description,
    authors,
    publisher,
    thumbnail,
    infoLink,
  ];
}
