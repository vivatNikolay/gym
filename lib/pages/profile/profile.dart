import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/user_settings_provider.dart';
import '../../providers/account_provider.dart';
import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../widgets/visits_list.dart';
import 'settings/settings_page.dart';
import 'widgets/profile_box.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountPr>(context, listen: false).account!;
    return Drawer(
      backgroundColor: Theme.of(context).primaryColor,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 246,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [mainColor, mainColor.withOpacity(0.9)],
                ),
              ),
              child: const ProfileBox(),
            ),
          ),
          const SizedBox(height: 6),
          ..._optionalTiles(context, account),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Настройки', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).pushNamed(SettingsPage.routeName);
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Выход', style: TextStyle(fontSize: 18)),
            onTap: () async {
              Navigator.of(context).pop();
              Provider.of<AccountPr>(context, listen: false).logout();
              Provider.of<UserSettingsPr>(context, listen: false).delete();
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _optionalTiles(BuildContext context, Account account) {
    if (account.role == 'USER') {
      return [
        ListTile(
          leading: const Icon(Icons.history, color: mainColor),
          minLeadingWidth: 24,
          title: const Text('История', style: TextStyle(fontSize: 18)),
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VisitsList(
                      title: 'История всех посещений',
                      accountId: account.id!,
                    )));
          },
        ),
      ];
    }
    return [];
  }
}
