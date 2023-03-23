import 'package:hive/hive.dart';

import '../../models/manager_settings.dart';
import 'db_service.dart';

class ManagerSettingsDBService extends DBService<ManagerSettings> {

  final box = Hive.box<ManagerSettings>('manager_settings');

  @override
  void put(ManagerSettings settings) {
    box.put(0, settings);
  }

  @override
  void deleteAll() {
    box.deleteAll(box.keys);
  }

  @override
  ManagerSettings getFirst() {
    return box.get(0) ?? ManagerSettings();
  }
}