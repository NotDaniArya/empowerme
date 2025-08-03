import 'package:new_empowerme/core/failure.dart';

import '../entitites/berita.dart';

abstract class BeritaRepository {
  Future<(List<Berita>?, Failure?)> getBeritaList();
}
