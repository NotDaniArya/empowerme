import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/obat.dart';

abstract class ObatRepository {
  Future<(List<Obat>?, Failure?)> getObat();

  Future<(void, Failure?)> postObat({
    required String title,
    required String source,
    required String date,
    required String snippet,
    required String link,
  });
}
