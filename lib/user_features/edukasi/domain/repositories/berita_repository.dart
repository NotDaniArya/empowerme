import 'package:new_empowerme/core/failure.dart';

import '../entitites/berita.dart';

abstract class BeritaRepository {
  Future<(List<Berita>?, Failure?)> getBeritaList();

  Future<(void, Failure?)> postBerita({
    required String title,
    required String author,
    required String description,
    required String publishedDate,
    required String url,
  });
}
