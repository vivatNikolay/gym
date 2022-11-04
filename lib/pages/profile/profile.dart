import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';

import '../../pages/profile/profile_edit.dart';
import '../../models/sportsman.dart';
import '../../services/db/sportsman_db_service.dart';
import 'settings/settings.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final SportsmanDBService _sportsmanDBService = SportsmanDBService();
  Sportsman? sportsman;

  @override
  void initState() {
    super.initState();

    sportsman = _sportsmanDBService.getFirst();
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
                      image: AssetImage(sportsman!.gender ? manImage : womanImage),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(50.0)),
                  ),
                ),
                minLeadingWidth: 24,
                title: Tooltip(
                  message: sportsman!.firstName,
                  child: Text(
                      sportsman!.firstName,
                      maxLines: 2,
                      style:
                          const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ),
                subtitle: Tooltip(
                  message: sportsman!.email,
                  child: Text(
                      sportsman!.email,
                      maxLines: 2,
                      style: const TextStyle(fontSize: 19)),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.edit, size: 28),
                  splashColor: mainColor,
                  splashRadius: 26,
                  onPressed: ()  async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ProfileEdit()));
                    setState(() {
                      sportsman = _sportsmanDBService.getFirst();
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
                _sportsmanDBService.deleteAll();
              },
            ),
          ],
        ),
      ),
    );
  }
}
