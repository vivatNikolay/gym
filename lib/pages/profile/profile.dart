import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';
import 'package:sportmen_in_gym/pages/profile/profile_edit.dart';

import '../../controllers/db_controller.dart';
import '../../models/sportsman.dart';
import '../qr_code/history.dart';
import 'settings/settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DBController _dbController = DBController.instance;
  Sportsman? sportsman;

  @override
  void initState() {
    super.initState();

    sportsman = _dbController.getSportsman();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
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
                  width: 70.0,
                  height: 70.0,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(sportsman!.gender ? 'images/man.png' : 'images/woman.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                minLeadingWidth: 24,
                title: Text(sportsman!.firstName,
                    style:
                        const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                subtitle: Text(sportsman!.email,
                    style: const TextStyle(fontSize: 20)),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 28),
                  splashColor: mainColor,
                  splashRadius: 26,
                  onPressed: ()  async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ProfileEdit(sportsman: sportsman!)));
                    setState(() {
                      sportsman = _dbController.getSportsman();
                    });
                  },
                ),
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
                _dbController.deleteAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
