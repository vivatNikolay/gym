import 'package:hive/hive.dart';

import '../../models/sportsman.dart';
import 'db_service.dart';

class SportsmanDBService extends DBService<Sportsman> {

  final box = Hive.box<Sportsman>('sportsman');

  @override
  void put(Sportsman sportsman) {
    box.put(0, sportsman);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  Sportsman? getFirst() {
    return box.get(0);
  }
}