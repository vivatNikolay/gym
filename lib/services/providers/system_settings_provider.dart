import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../models/system_settings.dart';
import '../db/system_settings_db_service.dart';

class SystemSettingsPr extends ChangeNotifier {
  final SystemSettingsDBService _dbService = SystemSettingsDBService();

  late ThemeMode themeMode;
  late SystemSettings _settings;

  SystemSettingsPr() {
    _settings = _dbService.getFirst() ?? SystemSettings(isDark: true);
    themeMode = initThemeMode();
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  void toggleTheme(bool isOn) {
    themeMode = isOn ? ThemeMode.dark : ThemeMode.light;
    _settings.isDark = isOn;
    _dbService.put(_settings);
    notifyListeners();
  }

  ThemeMode initThemeMode() {
    _dbService.put(_settings);
    if (_settings.isDark) {
      return ThemeMode.dark;
    }
    return ThemeMode.light;
  }
}

class MyThemes {
  static final light = ThemeData(
    colorScheme:
        const ColorScheme.light(primary: mainColor, secondary: mainColor),
    brightness: Brightness.light,
    primaryColor: Colors.white,
    backgroundColor: const Color(0xFFF3F3F8),
    appBarTheme: AppBarTheme(
      backgroundColor: mainColor.withOpacity(0.9),
      titleTextStyle:
          const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      titleSpacing: 18,
      centerTitle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25),
        ),
      ),
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(
        color: Colors.black54,
      ),
    ),
    iconTheme: const IconThemeData(
      color: Colors.black54,
    ),
    textSelectionTheme: const TextSelectionThemeData(
      cursorColor: mainColor,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: mainColor),
        borderRadius: BorderRadius.all(Radius.circular(15.0)),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
    ),
  );

  static final dark = ThemeData(
      colorScheme:
          const ColorScheme.dark(primary: mainColor, secondary: mainColor),
      brightness: Brightness.dark,
      backgroundColor: const Color(0xFF1C1C1E),
      scaffoldBackgroundColor: const Color(0xFF1C1C1E),
      appBarTheme: AppBarTheme(
        backgroundColor: mainColor.withOpacity(0.9),
        titleTextStyle:
            const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        titleSpacing: 18,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
          ),
        ),
      ),
      textTheme: const TextTheme(
        bodyMedium: TextStyle(
          color: Colors.white54,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Colors.white54,
      ),
      textSelectionTheme: const TextSelectionThemeData(
        cursorColor: mainColor,
      ),
      inputDecorationTheme: const InputDecorationTheme(
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      snackBarTheme: const SnackBarThemeData(
        backgroundColor: Colors.white60,
      ));
}