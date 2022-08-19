import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';

import '../controllers/db_controller.dart';
import 'login/login.dart';
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
        title: const Text('Profile'),
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 5),
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              child: ListTile(
                leading: Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(_dbController.getSportsman()!.gender ? 'images/man.png' : 'images/woman.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                    border: Border.all(
                      color: Colors.white24,
                      width: 1.0,
                    ),
                  ),
                ),
                minLeadingWidth: 24,
                title: Text(_dbController.getSportsman()!.firstName,
                    style:
                        const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                subtitle: Text(_dbController.getSportsman()!.email,
                    style: const TextStyle(fontSize: 20)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 26),
                  splashColor: mainColor,
                  splashRadius: 24,
                  onPressed: () {},
                ),
              ),
            ),
            const SizedBox(height: 15),
            ListTile(
              leading: const Icon(Icons.list_alt_rounded,
                  color: mainColor),
              minLeadingWidth: 24,
              title: const Text('History', style: TextStyle(fontSize: 18)),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const History()));
              },
            ),
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
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => const Login()));
                _dbController.deleteAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
