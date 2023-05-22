import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../models/account.dart';
import '../../../models/user_settings.dart';
import '../../../pages/profile/settings/password_changer.dart';
import '../../../helpers/constants.dart';
import '../../../pages/profile/settings/widgets/setting_name.dart';
import '../../../pages/profile/settings/widgets/setting_pack.dart';
import '../../../pages/profile/settings/widgets/setting_title.dart';
import '../../../providers/account_provider.dart';
import '../../../providers/system_settings_provider.dart';
import '../../../providers/user_settings_provider.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isInit = true;
  late bool _isDarkMode;
  late bool _oldIsDarkMode;
  late UserSettings _userSettings;
  late UserSettings _oldUserSettings;
  late Account _account;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _account = Provider.of<AccountPr>(context, listen: false).account!;
      _oldIsDarkMode =
          Provider.of<SystemSettingsPr>(context, listen: false).isDarkMode;
      _oldUserSettings =
          Provider.of<UserSettingsPr>(context, listen: false).settings!;
      _isDarkMode = _oldIsDarkMode;
      _userSettings = UserSettings(
        id: _account.id,
        defaultExerciseSets: _oldUserSettings.defaultExerciseSets,
        defaultExerciseReps: _oldUserSettings.defaultExerciseReps,
        defaultMembershipTime: _oldUserSettings.defaultMembershipTime,
        defaultMembershipNumber: _oldUserSettings.defaultMembershipNumber,
      );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  void _save() {
    if (_userSettings != _oldUserSettings) {
      Provider.of<UserSettingsPr>(context, listen: false)
          .put(_userSettings);
    }
    if (_isDarkMode != _oldIsDarkMode) {
      Provider.of<SystemSettingsPr>(context, listen: false)
          .toggleTheme(_isDarkMode);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
        actions: [
          IconButton(
            onPressed: _save,
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: ListView(
          padding: const EdgeInsets.all(10.0),
          children: [
            SettingTitle(text: 'Главные'),
            SettingPack(children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                minLeadingWidth: 24,
                title: const Text('Темная тема'),
                subtitle: Text(_isDarkMode ? 'включено' : 'выключено'),
                trailing: Switch(
                  value: _isDarkMode,
                  onChanged: (value) {
                    setState(() {
                      _isDarkMode = value;
                    });
                  },
                  activeColor: mainColor,
                ),
              ),
            ]),
            optionalPart(),
            SettingTitle(text: 'Безопасность'),
            SettingPack(children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                minLeadingWidth: 24,
                title: const Text('Сменить пароль'),
                onTap: () {
                  Navigator.of(context).pushNamed(PasswordChanger.routeName);
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  Widget optionalPart() {
    return _account.role == 'MANAGER'
        ? Column(
            children: [
              SettingTitle(text: 'Абонемент'),
              SettingPack(children: [
                const SizedBox(height: 15),
                const SettingName(text: 'Стандартная длительность(мес.):'),
                SfSlider(
                  min: 0,
                  max: 12,
                  interval: 3,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _userSettings.defaultMembershipTime,
                  onChanged: (value) {
                    setState(() {
                      _userSettings.defaultMembershipTime = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
                const SettingName(text: 'Стандартное кол-во посещений:'),
                SfSlider(
                  min: 0,
                  max: 50,
                  interval: 10,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _userSettings.defaultMembershipNumber,
                  onChanged: (value) {
                    setState(() {
                      _userSettings.defaultMembershipNumber = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
              ]),
            ],
          )
        : Column(
            children: [
              SettingTitle(text: 'Тренировки'),
              SettingPack(children: [
                const SizedBox(height: 15),
                const SettingName(text: 'Стандартное кол-во сетов:'),
                SfSlider(
                  min: 0,
                  max: 10,
                  interval: 5,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _userSettings.defaultExerciseSets,
                  onChanged: (value) {
                    setState(() {
                      _userSettings.defaultExerciseSets = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
                const SettingName(text: 'Стандартное кол-во повторений:'),
                SfSlider(
                  min: 0,
                  max: 30,
                  interval: 10,
                  showLabels: true,
                  enableTooltip: true,
                  activeColor: mainColor,
                  value: _userSettings.defaultExerciseReps,
                  onChanged: (value) {
                    setState(() {
                      _userSettings.defaultExerciseReps = value.toInt();
                    });
                  },
                ),
                const SizedBox(height: 15),
              ]),
            ],
          );
  }
}
