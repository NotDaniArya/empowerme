import 'package:flutter_riverpod/flutter_riverpod.dart';

final navigationIndexProvider = StateProvider<int>((ref) => 0);

final jadwalCategoryFilterProvider = StateProvider<String>((ref) => 'all');
