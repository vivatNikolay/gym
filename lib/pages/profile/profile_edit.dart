import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/controllers/db_controller.dart';
import 'package:sportmen_in_gym/models/sportsman.dart';

import '../../controllers/http_controller.dart';

class ProfileEdit extends StatefulWidget {
  final Sportsman sportsman;

  const ProfileEdit({required this.sportsman, Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState(sportsman);
}

class _ProfileEditState extends State<ProfileEdit> {
  final Sportsman sportsman;
  final HttpController _httpController = HttpController.instance;
  final DBController _dbController = DBController.instance;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  _ProfileEditState(this.sportsman);

  @override
  void initState() {
    _nameController.text = sportsman.firstName;
    _phoneController.text = sportsman.phone;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
              onPressed: () async {
                sportsman.firstName = _nameController.text.trim();
                sportsman.phone = _phoneController.text.trim();
                bool success = await _httpController.putSportsman(sportsman);
                if (success) {
                  _dbController.saveOrUpdateSportsman(sportsman);
                }
                Navigator.pop(context);
              },
              icon: const Icon(Icons.check))
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
          child: Column(
              children: [
                TextField(
                  controller: _nameController,
                ),
                TextField(
                  controller: _phoneController,
                ),
              ],
          ),
        ),
      ),
    );
  }
}
