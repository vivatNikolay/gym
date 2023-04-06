import 'package:hive/hive.dart';

import '../../models/user_settings.dart';

class UserSettingsDBService {

  final box = Hive.box<UserSettings>('user_settings');

  UserSettings getFirst() {
    return box.get(0) ?? UserSettings();
  }

  void put(UserSettings settings) {
    box.put(0, settings);
  }
}