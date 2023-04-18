import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../http/visit_http_service.dart';
import '../../models/visit.dart';
import '../../providers/account_provider.dart';
import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../widgets/visits_list.dart';
import 'settings/settings.dart';
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      Settings(isManager: account.role == 'MANAGER')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Выход', style: TextStyle(fontSize: 18)),
            onTap: () async {
              Navigator.of(context).pop();
              Provider.of<AccountPr>(context, listen: false).delete();
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
          onTap: () async {
            try {
              List<Visit> visits = await VisitHttpService()
                  .getByAccount(account);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      VisitsList(
                        visits: visits,
                        title: 'История всех посещений',
                      )));
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(e.toString()),
              ));
            }
          },
        ),
      ];
    }
    return [];
  }
}
