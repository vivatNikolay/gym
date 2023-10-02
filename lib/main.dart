import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'models/available_locale.dart';
import 'pages/login/login.dart';
import 'models/system_settings.dart';
import 'pages/home.dart';
import 'pages/main_page/manager/widgets/qr_scan_page.dart';
import 'pages/profile/profile_edit/profile_edit.dart';
import 'pages/profile/settings/password_changer.dart';
import 'pages/profile/settings/settings_page.dart';
import 'pages/splash.dart';
import 'providers/account_provider.dart';
import 'providers/system_settings_provider.dart';
import 'providers/user_settings_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await hiveInitialization();

  runApp(const MyApp());
}

Future<void> hiveInitialization() async {
  await Hive.initFlutter();
  Hive.registerAdapter(SystemSettingsAdapter());
  await Hive.openBox<SystemSettings>('system_settings');
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
          LocalJsonLocalization.delegate.directories = ['i18n'];
          final systemSettingsPr = Provider.of<SystemSettingsPr>(context);

          return MaterialApp(
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              LocalJsonLocalization.delegate,
            ],
            supportedLocales: AvailableLocale.values.map((e) => e['locale']),
            locale: systemSettingsPr.locale,
            title: 'Gym',
            darkTheme: MyThemes.dark,
            theme: MyThemes.light,
            themeMode: systemSettingsPr.themeMode,
            home: StreamBuilder(
              stream: FirebaseAuth.instance.userChanges(),
              builder: (ctx, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Splash();
                }
                if (snapshot.hasData) {
                  return const Home();
                } else {
                  return const Login();
                }
              },
            ),
            routes: {
              PasswordChanger.routeName: (ctx) => const PasswordChanger(),
              ProfileEdit.routeName: (ctx) => const ProfileEdit(),
              QrScanPage.routeName: (ctx) => const QrScanPage(),
              SettingsPage.routeName: (ctx) => const SettingsPage(),
            },
          );
        },
      );
}
