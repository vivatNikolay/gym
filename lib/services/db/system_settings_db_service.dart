import 'package:hive/hive.dart';

import '../../models/system_settings.dart';
import 'db_service.dart';

class SystemSettingsDBService extends DBService<SystemSettings> {

  final box = Hive.box<SystemSettings>('system_settings');

  @override
  void put(SystemSettings settings) {
    box.put(0, settings);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  SystemSettings? getFirst() {
    return box.get(0);
  }
}