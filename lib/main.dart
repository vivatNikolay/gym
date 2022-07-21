import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'services/theme/theme_provider.dart';
import 'models/settings.dart';
import 'pages/home.dart';
import 'controllers/db_controller.dart';
import 'models/sportsman.dart';
import 'models/subscription.dart';
import 'models/visit.dart';
import 'pages/login.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(SportsmanAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(VisitAdapter());
  Hive.registerAdapter(SettingsAdapter());
  await Hive.openBox<Sportsman>('sportsman');
  await Hive.openBox<Settings>('settings');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final DBController _dbController = DBController.instance;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => ThemeProvider(),
        builder: (context, _) {
          final themeProvider = Provider.of<ThemeProvider>(context);

          StatefulWidget home;
          if (_dbController.isHasSportsman()) {
            home = const Home();
          } else {
            home = const Login();
          }
          return MaterialApp(
            title: 'Gym',
            darkTheme: MyThemes.dark,
            theme: MyThemes.light,
            themeMode: themeProvider.themeMode,
            home: home,
          );
        },
      );
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
