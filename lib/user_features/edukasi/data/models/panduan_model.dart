import 'package:new_empowerme/user_features/edukasi/domain/entitites/panduan.dart';

class PanduanModel extends Panduan {
  const PanduanModel({
    required super.id,
    required super.title,
    required super.publishedDate,
    required super.description,
    required super.authors,
    required super.publisher,
    required super.thumbnail,
    required super.infoLink,
  });

  factory PanduanModel.fromJson(Map<String, dynamic> json) {
    final volumeInfo = json['volumeInfo'] as Map<String, dynamic>;

    return PanduanModel(
      id: json['id'],
      title: volumeInfo['title'] ?? 'Judul tidak tersedia',
      publishedDate: volumeInfo['publishedDate'] ?? '',
      description: volumeInfo['description'] ?? 'Deskripsi tidak tersedia',
      authors: volumeInfo['authors'] != null
          ? List<String>.from(volumeInfo['authors'])
          : [],
      publisher: volumeInfo['publisher'] ?? 'Sumber tidak diketahui',
      thumbnail: volumeInfo['imageLinks']['thumbnail'] ?? '',
      infoLink: volumeInfo['infoLink'],
    );
  }
}
