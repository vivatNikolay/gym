import 'package:flutter/material.dart';

import '../profile/profile.dart';

class MainScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? floatingActionButton;
  final Widget? bottomNavBar;

  const MainScaffold({
    required this.title,
    required this.body,
    this.floatingActionButton,
    this.bottomNavBar,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(title),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: floatingActionButton,
      drawer: const Profile(),
      body: body,
      bottomNavigationBar: bottomNavBar,
    );
  }
}
