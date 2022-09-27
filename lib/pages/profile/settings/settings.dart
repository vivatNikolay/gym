import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';
import 'package:sportmen_in_gym/pages/profile/settings/widgets/setting_pack.dart';
import 'package:sportmen_in_gym/pages/profile/settings/widgets/setting_title.dart';

import '../../../services/db/settings_db_service.dart';
import '../../../services/theme/theme_provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
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
            ],
          ),
        ),
      ),
    );
  }
}
