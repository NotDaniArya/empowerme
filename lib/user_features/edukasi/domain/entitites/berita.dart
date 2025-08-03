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
        'https://mobeng.id/wp-content/uploads/2021/10/placeholder-1-1.png';
    if (urlToImage.isNotEmpty) {
      return urlToImage;
    }
    return placeholder;
  }

  String get formattedPublishedAt {
    if (publishedAt.isEmpty) return 'Tanggal tidak tersedia';

    try {
      final dateTime = DateTime.parse(publishedAt);
      return DateFormat('d MMMM yyyy', 'id_ID').format(dateTime);
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
