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
      body: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.transparent.withOpacity(0.58),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [mainColor, Color(0xFF413278)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.fromLTRB(20, 0, 15, 0),
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        child:
                            Image.asset(sportsman!.gender ? manImage : womanImage),
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Tooltip(
                          message: sportsman!.firstName,
                          child: Text(sportsman!.firstName,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white)),
                        ),
                        Tooltip(
                          message: sportsman!.email,
                          child: Text(sportsman!.email,
                              maxLines: 2,
                              style: const TextStyle(
                                  fontSize: 19, color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: IconButton(
                    icon: const Icon(Icons.edit, size: 30, color: Colors.white),
                    splashColor: Colors.white,
                    splashRadius: 30,
                    onPressed: () async {
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
              ],
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
    );
  }
}
