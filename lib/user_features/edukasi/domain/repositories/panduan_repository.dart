import 'package:new_empowerme/core/failure.dart';
import 'package:new_empowerme/user_features/edukasi/domain/entitites/panduan.dart';

abstract class PanduanRepository {
  Future<(List<Panduan>?, Failure?)> getPanduanList();

  Future<(void, Failure?)> postPanduan({
    required String title,
    required String description,
    required String publishers,
    required String publishedDate,
    required String infoLink,
  });
}
