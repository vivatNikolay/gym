import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user_settings.dart';
import 'models/visit.dart';
import 'models/account.dart';
import 'models/subscription.dart';
import 'pages/login/login.dart';
import 'models/training.dart';
import 'models/exercise.dart';
import 'models/system_settings.dart';
import 'pages/home.dart';
import 'providers/account_provider.dart';
import 'providers/system_settings_provider.dart';
import 'providers/user_settings_provider.dart';
import 'providers/training_provider.dart';

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
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: SystemSettingsPr(),
          ),
          ChangeNotifierProvider.value(
            value: UserSettingsPr(),
          ),
          ChangeNotifierProvider.value(
            value: TrainingPr(),
          ),
          ChangeNotifierProvider.value(
            value: AccountPr(),
          ),
        ],
        builder: (context, _) {
          final systemSettingsPr = Provider.of<SystemSettingsPr>(context);
          final account = Provider.of<AccountPr>(context).account;

          return MaterialApp(
            title: 'Gym',
            darkTheme: MyThemes.dark,
            theme: MyThemes.light,
            themeMode: systemSettingsPr.themeMode,
            home: account != null ? const Home() : const Login(),
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
