import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../models/manager_settings.dart';
import '../../../pages/profile/settings/password_changer.dart';
import '../../../helpers/constants.dart';
import '../../../models/training_settings.dart';
import '../../../pages/profile/settings/widgets/setting_name.dart';
import '../../../pages/profile/settings/widgets/setting_pack.dart';
import '../../../pages/profile/settings/widgets/setting_title.dart';
import '../../../services/db/training_settings_db_service.dart';
import '../../../services/db/manager_settings_db_service.dart';
import '../../../services/providers/system_settings_provider.dart';

class Settings extends StatefulWidget {
  final bool isManager;

  const Settings({required this.isManager, Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final TrainingSettingsDBService _trainingDBService =
      TrainingSettingsDBService();
  final ManagerSettingsDBService _managerDBService = ManagerSettingsDBService();
  late TrainingSettings _trainingSettings;
  late ManagerSettings _managerSettings;

  @override
  initState() {
    super.initState();

    _trainingSettings = _trainingDBService.getFirst();
    _managerSettings = _managerDBService.getFirst();
  }

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
            ...widget.isManager ? managerPart() : sportsmanPart(),
            SettingTitle(text: 'Безопасность'),
            SettingPack(children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                minLeadingWidth: 24,
                title: const Text('Сменить пароль'),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PasswordChanger()));
                },
              ),
            ])
          ],
        ),
      ),
    );
  }

  List<Widget> sportsmanPart() {
    return [
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
          value: _trainingSettings.defaultExerciseSets,
          onChanged: (value) {
            setState(() {
              _trainingSettings.defaultExerciseSets = value.toInt();
              _trainingDBService.put(_trainingSettings);
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
          value: _trainingSettings.defaultExerciseReps,
          onChanged: (value) {
            setState(() {
              _trainingSettings.defaultExerciseReps = value.toInt();
              _trainingDBService.put(_trainingSettings);
            });
          },
        ),
        const SizedBox(height: 15),
      ]),
    ];
  }

  List<Widget> managerPart() {
    return [
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
          value: _managerSettings.defaultMembershipTime,
          onChanged: (value) {
            setState(() {
              _managerSettings.defaultMembershipTime = value.toInt();
              _managerDBService.put(_managerSettings);
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
          value: _managerSettings.defaultMembershipNumber,
          onChanged: (value) {
            setState(() {
              _managerSettings.defaultMembershipNumber = value.toInt();
              _managerDBService.put(_managerSettings);
            });
          },
        ),
        const SizedBox(height: 15),
      ]),
    ];
  }
}
