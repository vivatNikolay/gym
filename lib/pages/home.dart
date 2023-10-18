import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../models/account.dart';
import '../models/custom_icons.dart';
import '../providers/user_settings_provider.dart';
import '../helpers/constants.dart';
import '../providers/account_provider.dart';
import 'main_page/admin/admin_page.dart';
import 'main_page/manager/manager_qr_page.dart';
import 'main_page/sportsman/sportsman_qr_page.dart';
import 'training_list/training_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isInit = true;
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      Provider.of<AccountPr>(context, listen: false).init();
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Account? account = Provider.of<AccountPr>(context).account;
    Provider.of<UserSettingsPr>(context, listen: false).init();
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage(_selectedIndex == 0 ? gantelImage : trainingListImage),
          fit: BoxFit.cover,
          opacity: 0.65,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: account != null
          ? IndexedStack(
              index: _selectedIndex,
              children: _widgetsByRole(
                account.role,
                _widgetsByRole(account.role).length > 1
                    ? ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(30.0),
                        ),
                        child: BottomNavigationBar(
                          selectedItemColor: mainColor,
                          items: _bottomItemsByRole(account.role),
                          currentIndex: _selectedIndex,
                          onTap: _onItemTapped,
                          iconSize: 26,
                          backgroundColor: Theme.of(context).colorScheme.background,
                        ),
                      )
                    : null,
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  List<Widget> _widgetsByRole(String role, [Widget? bottomNavBar]) {
    switch (role) {
      case 'MANAGER':
        {
          return const [ManagerQrPage()];
        }
      case 'ADMIN':
        {
          return const [AdminPage()];
        }
    }
    return [
      SportsmanQrPage(bottomNavBar: bottomNavBar),
      TrainingList(bottomNavBar: bottomNavBar),
    ];
  }

  List<BottomNavigationBarItem> _bottomItemsByRole(String role) {
    switch (role) {
      case 'MANAGER':
        {
          return [
            BottomNavigationBarItem(
              icon: const Icon(Icons.qr_code),
              label: 'qrCode'.i18n(),
            ),
          ];
        }
      case 'ADMIN':
        {
          return [
            BottomNavigationBarItem(
              icon: const Icon(Icons.admin_panel_settings),
              label: 'adminPage'.i18n(),
            ),
          ];
        }
    }
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.qr_code),
        label: 'qrCode'.i18n(),
      ),
      BottomNavigationBarItem(
        icon: const Icon(CustomIcons.dumbbell),
        label: 'trainings'.i18n(),
      ),
    ];
  }
}
