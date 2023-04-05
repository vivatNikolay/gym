import 'package:hive/hive.dart';

import '../../models/system_settings.dart';

class SystemSettingsDBService {

  final box = Hive.box<SystemSettings>('system_settings');

  void put(SystemSettings settings) {
    box.put(0, settings);
  }

  void deleteAll() {
    box.deleteAll(box.keys);
  }

  SystemSettings? getFirst() {
    return box.get(0);
  }
}