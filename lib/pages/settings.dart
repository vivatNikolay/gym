import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';

import '../services/theme/theme_provider.dart';

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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [ListTile(
                leading: const Icon(Icons.dark_mode_outlined),
                minLeadingWidth: 24,
                title: const Text('Dark mode'),
                subtitle: Text(themeProvider.isDarkMode ? 'enabled' : 'disabled'),
                //что-то такое
                trailing: Switch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                  activeColor: mainColor,
                ),
                onTap: () {},
              ),
          ],
        ),
      ),
    );
  }
}
