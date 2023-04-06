import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user_settings.dart';
import 'models/visit.dart';
import 'services/db/account_db_service.dart';
import 'services/providers/system_settings_provider.dart';
import 'models/system_settings.dart';
import 'pages/home.dart';
import 'models/account.dart';
import 'models/subscription.dart';
import 'pages/login/login.dart';
import 'models/training.dart';
import 'models/exercise.dart';
import 'services/providers/user_settings_provider.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  await hiveInitialization();

  runApp(MyApp());
}

Future<void> hiveInitialization() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(AccountAdapter());
  Hive.registerAdapter(SubscriptionAdapter());
  Hive.registerAdapter(SystemSettingsAdapter());
  Hive.registerAdapter(UserSettingsAdapter());
  Hive.registerAdapter(TrainingAdapter());
  Hive.registerAdapter(ExerciseAdapter());
  Hive.registerAdapter(VisitAdapter());
  await Hive.openBox<Account>('account');
  await Hive.openBox<SystemSettings>('system_settings');
  await Hive.openBox<UserSettings>('user_settings');
  await Hive.openBox<Training>('training');
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final AccountDBService _accountDBService = AccountDBService();

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SystemSettingsPr(),
          ),
          ChangeNotifierProvider.value(
            value: UserSettingsPr(),
          ),
        ],
        builder: (context, _) {
          final systemSettingsPr = Provider.of<SystemSettingsPr>(context);

          String initialRoute = 'login';
          if (_accountDBService.getFirst() != null) {
            initialRoute = 'home';
          }
          return MaterialApp(
            title: 'Gym',
            darkTheme: MyThemes.dark,
            theme: MyThemes.light,
            themeMode: systemSettingsPr.themeMode,
            initialRoute: initialRoute,
            routes: {
              'home': (context) => const Home(),
              'login': (context) => const Login(),
            },
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
