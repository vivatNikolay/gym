import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../pages/profile/settings/password_changer.dart';
import '../../../helpers/constants.dart';
import '../../../models/training_settings.dart';
import '../../../pages/profile/settings/widgets/setting_name.dart';
import '../../../pages/profile/settings/widgets/setting_pack.dart';
import '../../../pages/profile/settings/widgets/setting_title.dart';
import '../../../services/db/training_settings_db_service.dart';
import '../../../services/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final TrainingSettingsDBService _dbService = TrainingSettingsDBService();
  late TrainingSettings _trainingSettings;

  @override
  initState() {
    _trainingSettings = _dbService.getFirst();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              SettingTitle(text: 'General'),
              SettingPack(children: [
                ListTile(
                  leading: const Icon(Icons.dark_mode_outlined),
                  minLeadingWidth: 24,
                  title: const Text('Dark mode'),
                  subtitle:
                      Text(themeProvider.isDarkMode ? 'enabled' : 'disabled'),
                  trailing: Switch(
                    value: themeProvider.isDarkMode,
                    onChanged: (value) {
                      themeProvider.toggleTheme(value);
                    },
                    activeColor: mainColor,
                  ),
                ),
              ]),
              SettingTitle(text: 'Training'),
              SettingPack(children: [
                const SizedBox(height: 15),
                SettingName(text: 'Default sets count:'),
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
                      _dbService.put(_trainingSettings);
                    });
                  },
                ),
                const SizedBox(height: 15),
                SettingName(text: 'Default reps count:'),
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
                      _dbService.put(_trainingSettings);
                    });
                  },
                ),
                const SizedBox(height: 15),
              ]),
              SettingTitle(text: 'Security'),
              SettingPack(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.lock_outline),
                      minLeadingWidth: 24,
                      title: const Text('Change password'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const PasswordChanger()));
                      },
                    ),
                  ])
            ],
          ),
        ),
      ),
    );
  }
}
