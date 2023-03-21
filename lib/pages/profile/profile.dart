import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../../services/db/account_db_service.dart';
import 'profile_edit/profile_edit.dart';
import 'settings/settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(
            height: 238,
            child: DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomCenter,
                  colors: [
                    mainColor,
                    mainColor.withOpacity(0.9)
                  ],
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
                        child: const Icon(Icons.edit, color: mainColor, size: 28),
                        style: ElevatedButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: const EdgeInsets.all(10),
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Text(
                    '${account!.firstName ?? ''} ${account!.lastName}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    account!.email ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 5),
          ListTile(
            leading: const Icon(Icons.settings_outlined, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Настройки', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Выход', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.pushReplacementNamed(context, 'login');
              _accountDBService.deleteAll();
            },
          ),
        ],
      ),
    );
  }
}
