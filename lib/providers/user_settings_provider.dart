import 'package:flutter/material.dart';

import '../services/user_settings_fire.dart';
import '../../models/user_settings.dart';

class UserSettingsPr extends ChangeNotifier {

  final UserSettingsFire _settingsFire = UserSettingsFire();
  UserSettings? _settings;

  UserSettings? get settings {
    return _settings;
  }

  Future<void> init() async {
    if (_settings == null) {
      _settings = await _settingsFire.init();
      notifyListeners();
    }
  }

  void delete() {
    _settings = null;
    notifyListeners();
  }

  Future<void> put(UserSettings settings) async {
    _settings = settings;
    await _settingsFire.put(settings);
    notifyListeners();
  }
}
