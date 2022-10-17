import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/controllers/db_controller.dart';
import 'package:sportmen_in_gym/models/sportsman.dart';

import '../../controllers/http_controller.dart';
import '../../helpers/constants.dart';

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
    super.initState();

    _nameController.text = sportsman.firstName;
    _phoneController.text = sportsman.phone;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15).copyWith(top: 20),
          child: Column(
              children: [
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  controller: _nameController,
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                  controller: _phoneController,
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(140, 42),
                      primary: mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () async {
                      sportsman.firstName = _nameController.text.trim();
                      sportsman.phone = _phoneController.text.trim();
                      bool success = await _httpController.putSportsman(sportsman);
                      if (success) {
                        _dbController.saveOrUpdateSportsman(sportsman);
                      }
                      Navigator.pop(context);
                    },
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
          ),
        ),
      ),
    );
  }
}
