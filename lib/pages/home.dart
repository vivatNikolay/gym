import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/user_settings_provider.dart';
import '../providers/account_provider.dart';
import 'main_page/admin/admin_page.dart';
import 'main_page/manager/manager_page.dart';
import 'main_page/sportsman/sportsman_page.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<AccountPr>(context, listen: false).init();
    final acc = Provider.of<AccountPr>(context).account;
    Provider.of<UserSettingsPr>(context, listen: false).init();
    if (acc != null) {
      switch (acc.role) {
        case 'MANAGER':
          return const ManagerPage();
        case 'ADMIN':
          return const AdminPage();
        default:
          return const SportsmanPage();
      }
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }
}
