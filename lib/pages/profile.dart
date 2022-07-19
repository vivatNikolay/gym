import 'package:flutter/material.dart';

import '../controllers/db_controller.dart';
import 'login.dart';
import 'history.dart';
import 'settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DBController _dbController = DBController.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_dbController.getSportsman()!.firstName, style: const TextStyle(fontSize: 24)),
      ),
      body: Column(
          children: [
        Flexible(
          flex: 1,
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.edit, color: Colors.deepOrangeAccent, size: 26),
                  onPressed: () {},
                ),
              ),
              Text(
                _dbController.getSportsman()!.firstName,
                style: const TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
              Text(
                _dbController.getSportsman()!.email,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepOrangeAccent,
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                ListTile(
                  leading: const Icon(Icons.list_alt_rounded,
                      color: Colors.deepOrangeAccent),
                  minLeadingWidth: 24,
                  title: const Text('History'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const History()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.settings_outlined,
                      color: Colors.deepOrangeAccent),
                  minLeadingWidth: 24,
                  title: const Text('Settings'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const Settings()));
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.deepOrangeAccent),
                  minLeadingWidth: 24,
                  title: const Text('Exit'),
                  onTap: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => const Login()));
                    _dbController.deleteAll();
                  },
                ),
              ],
            ),
          ),
        ),
      ]),
    );
  }
}
