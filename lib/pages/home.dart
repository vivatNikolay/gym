import 'package:flutter/material.dart';

import '../models/custom_icons.dart';
import '../helpers/constants.dart';
import '../db/account_db_service.dart';
import 'main_page/manager/manager_qr_page.dart';
import 'main_page/sportsman/sportsman_qr_page.dart';
import 'training_list/training_list.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AccountDBService _accountDBService = AccountDBService();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
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
        body: widgetsByRole().elementAt(_selectedIndex),
        bottomNavigationBar: widgetsByRole().length > 1
            ? ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(30.0),
                ),
                child: BottomNavigationBar(
                  selectedItemColor: mainColor,
                  items: bottomItemsByRole(),
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

  List<Widget> widgetsByRole() {
    switch (_accountDBService.getFirst()!.role) {
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

  List<BottomNavigationBarItem> bottomItemsByRole() {
    switch (_accountDBService.getFirst()!.role) {
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
