import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../models/user_settings.dart';
import '../../../pages/profile/settings/password_changer.dart';
import '../../../helpers/constants.dart';
import '../../../pages/profile/settings/widgets/setting_name.dart';
import '../../../pages/profile/settings/widgets/setting_pack.dart';
import '../../../pages/profile/settings/widgets/setting_title.dart';
import '../../../providers/system_settings_provider.dart';
import '../../../providers/user_settings_provider.dart';

class Settings extends StatefulWidget {
  final bool isManager;

  const Settings({required this.isManager, Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Настройки'),
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
              Consumer<SystemSettingsPr>(
                builder: (ctx, systemSettingsPr, _) => ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  minLeadingWidth: 24,
                  title: const Text('Темная тема'),
                  subtitle: Text(
                      systemSettingsPr.isDarkMode ? 'включено' : 'выключено'),
                  trailing: Switch(
                    value: systemSettingsPr.isDarkMode,
                    onChanged: (value) {
                      systemSettingsPr.toggleTheme(value);
                    },
                    activeColor: mainColor,
                  ),
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
    return Consumer<UserSettingsPr>(
        builder: (ctx, _userSettingsPr, _) {
          UserSettings _userSettings = _userSettingsPr.settings;
          return widget.isManager
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
                    _userSettings.defaultMembershipTime =
                        value.toInt();
                    _userSettingsPr.put(_userSettings);
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
                    _userSettings.defaultMembershipNumber =
                        value.toInt();
                    _userSettingsPr.put(_userSettings);
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
                    _userSettings.defaultExerciseSets =
                        value.toInt();
                    _userSettingsPr.put(_userSettings);
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
                    _userSettings.defaultExerciseReps =
                        value.toInt();
                    _userSettingsPr.put(_userSettings);
                  },
                ),
                const SizedBox(height: 15),
              ]),
            ],
          );
        });
  }
}
