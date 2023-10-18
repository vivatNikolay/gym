import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../widgets/main_scaffold.dart';
import '../../../helpers/constants.dart';
import '../../../models/custom_icons.dart';
import '../../widgets/floating_add_button.dart';
import 'sportsman_qr/sportsman_qr.dart';
import 'training_list/training_list.dart';
import 'widgets/add_training_dialog.dart';

class SportsmanPage extends StatefulWidget {
  const SportsmanPage({super.key});

  @override
  State<SportsmanPage> createState() => _SportsmanPageState();
}

class _SportsmanPageState extends State<SportsmanPage> {
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
          image: AssetImage(_backgroundImagePath()),
          fit: BoxFit.cover,
          opacity: 0.65,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: MainScaffold(
        title: _title(),
        body: IndexedStack(
          index: _selectedIndex,
          children: const [
            SportsmanQrPage(),
            TrainingList(),
          ],
        ),
        bottomNavBar: ClipRRect(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            selectedItemColor: mainColor,
            items: _bottomItems(),
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            iconSize: 26,
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
        ),
        floatingActionButton: _floatingActionButton(),
      ),
    );
  }

  List<BottomNavigationBarItem> _bottomItems() {
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

  String _backgroundImagePath() {
    switch (_selectedIndex) {
      case 0: return gantelImage;
      case 1: return trainingListImage;
      default: return gantelImage;
    }
  }

  String _title() {
    switch (_selectedIndex) {
      case 0: return 'qrCode'.i18n();
      case 1: return 'trainings'.i18n();
      default: return '';
    }
  }

  Widget? _floatingActionButton() {
    switch (_selectedIndex) {
      case 0: return null;
      case 1: return FloatingAddButton(
        text: 'addTraining'.i18n(),
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AddTrainingDialog(),
        ),
      );
      default: return null;
    }
  }
}
