import 'package:hive/hive.dart';

import '../../models/manager_settings.dart';

class ManagerSettingsDBService {

  final box = Hive.box<ManagerSettings>('manager_settings');

  void put(ManagerSettings settings) {
    box.put(0, settings);
  }

  void deleteAll() {
    box.deleteAll(box.keys);
  }

  ManagerSettings getFirst() {
    return box.get(0) ?? ManagerSettings();
  }
}