import 'package:hive/hive.dart';

import '../../models/system_settings.dart';
import 'hive_db.dart';

class SystemSettingsDB extends HiveDB<SystemSettings> {

  final box = Hive.box<SystemSettings>('system_settings');

  @override
  Future<void> put(SystemSettings? settings) async {
    if (settings != null) {
      await box.put(0, settings);
    }
  }

  @override
  Future<void> deleteAll() async {
    await box.deleteAll(box.keys);
  }

  @override
  SystemSettings? getFirst() {
    return box.get(0);
  }
}