import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/makanan.dart';

abstract class MakananRepository {
  Future<(List<Makanan>?, Failure?)> getMakanan();

  Future<(void, Failure?)> postMakanan({
    required String link,
    required String title,
    required String source,
    required String date,
    required String description,
  });
}
