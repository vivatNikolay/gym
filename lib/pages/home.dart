import 'package:flutter/material.dart';

import '../helpers/constants.dart';
import '../services/db/account_db_service.dart';
import 'main_page/manager/manager_qr_page.dart';
import 'main_page/qr_code.dart';
import 'main_page/sportsman/sportsman_qr_page.dart';
import 'training_list/training_list.dart';
import 'profile/profile.dart';

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
    return Scaffold(
      body: Center(
        child: widgetsByRole().elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: mainColor,
        items: bottomItemsByRole(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        showUnselectedLabels: false,
        showSelectedLabels: false,
        iconSize: 26,
      ),
    );
  }

  List<Widget> widgetsByRole() {
    switch (_accountDBService.getFirst()!.role) {
      case 'MANAGER':
        {
          return const [
            QrCode(ManagerQrPage()),
            Profile(),
          ];
        }
      case 'ADMIN':
        {
          break;
        }
    }
    return const [
      QrCode(SportsmanQrPage()),
      TrainingList(),
      Profile(),
    ];
  }

  List<BottomNavigationBarItem> bottomItemsByRole() {
    switch (_accountDBService.getFirst()!.role) {
      case 'MANAGER':
        {
          return const [
            BottomNavigationBarItem(
              icon: Icon(Icons.qr_code, size: 28),
              label: 'QR',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle, size: 28),
              label: 'Profile',
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
        icon: Icon(Icons.qr_code, size: 28),
        label: 'QR',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.sticky_note_2_outlined, size: 28),
        label: 'Training List',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_circle, size: 28),
        label: 'Profile',
      ),
    ];
  }
}
