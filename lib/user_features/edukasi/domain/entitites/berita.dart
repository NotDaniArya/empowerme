import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class Berita extends Equatable {
  final String title;
  final String author;
  final String urlToImage;
  final String publishedAt;
  final String description;
  final String url;

  const Berita({
    required this.title,
    required this.author,
    required this.urlToImage,
    required this.publishedAt,
    required this.description,
    required this.url,
  });

  // getter untuk mengecek apakah urlToImage null atau empty
  String get displayImageUrl {
    // placeholder jika tidak ada gambar
    const String placeholder =
        'https://obssr.od.nih.gov/sites/obssr/files/2025-05/red-ribbon-stethoscope.jpg';
    if (urlToImage.isNotEmpty && urlToImage != 'empty') {
      return urlToImage;
    }
    return placeholder;
  }

  String get formattedPublishedAt {
    if (publishedAt.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final dateTime = DateTime.parse(publishedAt);
      return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dateTime);
    } catch (e) {
      return publishedAt;
    }
  }

  @override
  // TODO: implement props
  List<Object?> get props => [
    title,
    author,
    urlToImage,
    publishedAt,
    description,
    url,
  ];
}
