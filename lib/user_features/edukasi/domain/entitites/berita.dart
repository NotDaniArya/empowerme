import 'package:equatable/equatable.dart';

class Berita extends Equatable {
  final String? title;
  final String? author;
  final String? urlToImage;
  final String? publishedAt;
  final String? description;
  final String? url;

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
    if (urlToImage != null && urlToImage!.isNotEmpty) {
      return urlToImage!;
    }
    return placeholder;
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
