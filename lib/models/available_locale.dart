import 'dart:ui';

class AvailableLocale {
  static const ru = {'locale': Locale('ru', 'RU'), 'title': 'Русский'};
  static const en = {'locale': Locale('en', 'US'), 'title': 'English'};

  static List<Map<String, dynamic>> values = [ru,en];
}