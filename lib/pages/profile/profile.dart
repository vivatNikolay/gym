import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../../services/db/account_db_service.dart';
import '../widgets/profile_row.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.58),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [mainColor, Color(0xFF46377D)],
              ),
            ),
            child: ProfileRow(
              account: account!,
              onEdit: () async {
                await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ProfileEdit(account: account!)));
                setState(() {
                  account = _accountDBService.getFirst();
                });
              },
            ),
          ),
          const SizedBox(height: 15),
          ListTile(
            leading: const Icon(Icons.settings_outlined,
                color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Settings', style: TextStyle(fontSize: 18)),
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const Settings()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout, color: mainColor),
            minLeadingWidth: 24,
            title: const Text('Exit', style: TextStyle(fontSize: 18)),
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
