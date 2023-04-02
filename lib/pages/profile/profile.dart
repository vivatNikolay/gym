import 'package:flutter/material.dart';

import '../../controllers/visit_http_controller.dart';
import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../../services/db/account_db_service.dart';
import '../widgets/visits_list.dart';
import 'profile_edit/profile_edit.dart';
import 'settings/settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final VisitHttpController _visitHttpController = VisitHttpController.instance;
  final AccountDBService _accountDBService = AccountDBService();
  Account? account;

  @override
  void initState() {
    super.initState();

    account = _accountDBService.getFirst();
  }

  @override
  Widget build(BuildContext context) {
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: mainColor,
                        radius: 50.0,
                        child: Image.asset(
                            'images/profileImg${account!.iconNum}.png'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProfileEdit(account: account!)));
                          setState(() {
                            account = _accountDBService.getFirst();
                          });
                        },
                        child: const Icon(
                          Icons.edit,
                          color: mainColor,
                          size: 28,
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${account!.firstName ?? ''} ${account!.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24.0,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    account!.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 6),
          ..._optionalTiles(),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Настройки', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      Settings(isManager: account?.role == 'MANAGER')));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Выход', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacementNamed(context, '/login');
              _accountDBService.deleteAll();
            },
          ),
        ],
      ),
    );
  }

  List<Widget> _optionalTiles() {
    if (account?.role == 'USER') {
      return [
        ListTile(
          leading: const Icon(Icons.history, color: mainColor),
          minLeadingWidth: 24,
          title: const Text('История', style: TextStyle(fontSize: 18)),
          onTap: () {
            _visitHttpController
                .getOwnVisitsByAccount()
                .then((value) => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => VisitsList(
                          visits: value,
                          title: 'История всех посещений',
                        ))));
          },
        ),
      ];
    }
    return [];
  }
}
