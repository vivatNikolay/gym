import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'models/user_settings.dart';
import 'models/visit.dart';
import 'models/account.dart';
import 'models/subscription.dart';
import 'pages/login/login.dart';
import 'models/system_settings.dart';
import 'pages/home.dart';
import 'pages/main_page/manager/widgets/qr_scan_page.dart';
import 'pages/profile/profile_edit/profile_edit.dart';
import 'pages/profile/settings/password_changer.dart';
import 'providers/account_provider.dart';
import 'providers/system_settings_provider.dart';
import 'providers/user_settings_provider.dart';

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await hiveInitialization();

  runApp(const MyApp());
}

Future<void> hiveInitialization() async {
  await Hive.initFlutter();
  Hive
    ..registerAdapter(AccountAdapter())
    ..registerAdapter(SubscriptionAdapter())
    ..registerAdapter(SystemSettingsAdapter())
    ..registerAdapter(UserSettingsAdapter())
    ..registerAdapter(VisitAdapter());
  await Hive.openBox<Account>('account');
  await Hive.openBox<SystemSettings>('system_settings');
  await Hive.openBox<UserSettings>('user_settings');
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
              PasswordChanger.routeName: (ctx) => const PasswordChanger(),
              ProfileEdit.routeName: (ctx) => const ProfileEdit(),
              QrScanPage.routeName: (ctx) => const QrScanPage(),
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
