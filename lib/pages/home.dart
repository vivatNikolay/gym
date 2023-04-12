import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/custom_icons.dart';
import '../helpers/constants.dart';
import '../providers/account_provider.dart';
import 'main_page/manager/manager_qr_page.dart';
import 'main_page/sportsman/sportsman_qr_page.dart';
import 'training_list/training_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final account = Provider.of<AccountPr>(context, listen: false).account;
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image:
              AssetImage(_selectedIndex == 0 ? gantelImage : trainingListImage),
          fit: BoxFit.cover,
          opacity: 0.75,
        ),
        color: Theme.of(context).backgroundColor,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: widgetsByRole(account!.role).elementAt(_selectedIndex),
        bottomNavigationBar: widgetsByRole(account.role).length > 1
            ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: mainColor,
                  items: bottomItemsByRole(account.role),
                  currentIndex: _selectedIndex,
                  onTap: _onItemTapped,
                  iconSize: 26,
                  backgroundColor: Theme.of(context).primaryColor,
                ),
              )
            : null,
      ),
    );
  }

  List<Widget> widgetsByRole(String role) {
    switch (role) {
      case 'MANAGER':
        {
          return const [
            ManagerQrPage(),
          ];
        }
      case 'ADMIN':
        {
          break;
        }
    }
    return const [
      SportsmanQrPage(),
      TrainingList(),
    ];
  }

  List<BottomNavigationBarItem> bottomItemsByRole(String role) {
    switch (role) {
      case 'MANAGER':
        {
          return const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code),
              label: 'QR-код',
            ),
          ];
        }
      case 'ADMIN':
        {
          break;
        }
    }
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.qr_code),
        label: 'QR-код',
      ),
      BottomNavigationBarItem(
        icon: Icon(CustomIcons.dumbbell),
        label: 'Тренировки',
      ),
    ];
  }
}
