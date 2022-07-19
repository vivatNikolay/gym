import 'package:hive/hive.dart';
import 'package:sportmen_in_gym/models/settings.dart';

import 'db_service.dart';

class SettingsDBService extends DBService<Settings> {

  final box = Hive.box<Settings>('settings');

  @override
  void put(Settings settings) {
    box.put(0, settings);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  Settings? getFirst() {
    return box.get(0);
  }
}