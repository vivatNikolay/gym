import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../../models/system_settings.dart';
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
import '../../widgets/loading_buttons/loading_icon_button.dart';
import 'widgets/locale_selector_dialog.dart';

class SettingsPage extends StatefulWidget {
  static const routeName = '/settings';

  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isInit = true;
  late SystemSettings _systemSettings;
  late SystemSettings _oldSystemSettings;
  late UserSettings _userSettings;
  late UserSettings _oldUserSettings;
  late Account _account;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _account = Provider.of<AccountPr>(context, listen: false).account!;
      _oldSystemSettings =
          Provider.of<SystemSettingsPr>(context, listen: false).settings;
      _systemSettings = SystemSettings(
          isDark: _oldSystemSettings.isDark, locale: _oldSystemSettings.locale);
      _oldUserSettings =
          Provider.of<UserSettingsPr>(context, listen: false).settings!;
      _userSettings = UserSettings(
        defaultExerciseSets: _oldUserSettings.defaultExerciseSets,
        defaultExerciseReps: _oldUserSettings.defaultExerciseReps,
        defaultMembershipTime: _oldUserSettings.defaultMembershipTime,
        defaultMembershipNumber: _oldUserSettings.defaultMembershipNumber,
      );
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  Future<void> _save() async {
    if (_userSettings != _oldUserSettings) {
      await Provider.of<UserSettingsPr>(context, listen: false)
          .put(_userSettings);
    }
    if (_systemSettings != _oldSystemSettings) {
      await Provider.of<SystemSettingsPr>(context, listen: false)
          .put(_systemSettings);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.i18n()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LoadingIconButton(
              onPressed: () async => _save(),
              icon: const Icon(Icons.check),
            ),
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
            SettingTitle(text: 'main'.i18n()),
            SettingPack(children: [
              ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                minLeadingWidth: 24,
                title: Text('darkMode'.i18n()),
                subtitle: Text(_systemSettings.isDark ? 'enable'.i18n() : 'disable'.i18n()),
                trailing: Switch(
                  value: _systemSettings.isDark,
                  onChanged: (value) {
                    setState(() {
                      _systemSettings.isDark = value;
                    });
                  },
                  activeColor: mainColor,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.language),
                minLeadingWidth: 24,
                title: Text('changeLang'.i18n()),
                onTap: () => showDialog(
                  context: context,
                  builder: (BuildContext context) => LocaleSelectorDialog(
                    selection: _systemSettings.locale,
                    action: (value) {
                      setState(() {
                        _systemSettings.locale = value;
                      });
                    },
                  ),
                ),
              ),
            ]),
            optionalPart(),
            SettingTitle(text: 'security'.i18n()),
            SettingPack(children: [
              ListTile(
                leading: const Icon(Icons.lock_outline),
                minLeadingWidth: 24,
                title: Text('changePassword'.i18n()),
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
              SettingTitle(text: 'membership'.i18n()),
              SettingPack(children: [
                const SizedBox(height: 15),
                SettingName(text: '${'standardDuration'.i18n()}:'),
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
                SettingName(text: '${'standardNumberOfVisits'.i18n()}:'),
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
              SettingTitle(text: 'trainings'.i18n()),
              SettingPack(children: [
                const SizedBox(height: 15),
                SettingName(text: '${'standardNumberOfSets'.i18n()}:'),
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
                SettingName(text: '${'standardNumberOfReps'.i18n()}:'),
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
