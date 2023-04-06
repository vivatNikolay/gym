import 'package:flutter/material.dart';

import '../../models/user_settings.dart';
import '../db/user_settings_db_service.dart';

class UserSettingsPr extends ChangeNotifier {

  UserSettings _settings = UserSettingsDBService().getFirst();

  UserSettings get settings {
    return _settings;
  }

  void put(UserSettings settings) {
    _settings = settings;
    UserSettingsDBService().put(settings);
    notifyListeners();
  }
}
