import 'package:flutter/material.dart';

import '../../models/sportsman.dart';
import '../../controllers/http_controller.dart';
import '../../helpers/constants.dart';
import '../../services/db/sportsman_db_service.dart';
import '../widgets/my_text_field.dart';

class ProfileEdit extends StatefulWidget {

  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  late Sportsman _sportsman;
  final HttpController _httpController = HttpController.instance;
  final SportsmanDBService _sportsmanDBService = SportsmanDBService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late ValueNotifier<bool> _nameValidator;
  late ValueNotifier<bool> _phoneValidator;
  late bool _gender;

  _ProfileEditState();

  @override
  void initState() {
    super.initState();

    _sportsman = _sportsmanDBService.getFirst()!;
    _nameController.text = _sportsman.firstName;
    _phoneController.text = _sportsman.phone;
    _nameValidator = ValueNotifier(true);
    _phoneValidator = ValueNotifier(true);
    _gender = _sportsman.gender;
  }

  @override
  void dispose() {
    _nameValidator.dispose();
    _phoneValidator.dispose();

    super.dispose();
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
                Row(
                  children: [
                    const SizedBox(
                        width: 65,
                        child: Text('Name:', style: TextStyle(fontSize: 16))
                    ),
                    Flexible(
                      child: MyTextField(
                        controller: _nameController,
                        validation: _nameValidator,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const SizedBox(
                      width: 65,
                      child: Text('Phone:', style: TextStyle(fontSize: 16))
                    ),
                    Flexible(
                      child: MyTextField(
                        controller: _phoneController,
                        validation: _phoneValidator,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                children: [
                  const SizedBox(
                      width: 65,
                      child: Text('Gender:', style: TextStyle(fontSize: 16))),
                  Radio(
                      activeColor: mainColor,
                      value: 'male',
                      groupValue: _gender ? 'male' : 'female',
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue == 'male';
                        });
                      }),
                  const Text("Male", style: TextStyle(fontSize: 18)),
                  Radio(
                      activeColor: mainColor,
                      value: 'female',
                      groupValue: _gender ? 'male' : 'female',
                      onChanged: (String? newValue) {
                        setState(() {
                          _gender = newValue == 'male';
                        });
                      }),
                  const Text(
                      "Female", style: TextStyle(fontSize: 18)
                  ),
                ],
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
                    if (validateFields()) {
                      bool success =
                          await _httpController.putSportsman(
                          Sportsman(
                              id: _sportsman.id,
                              email: _sportsman.email,
                              password: _sportsman.password,
                              phone: _phoneController.text.trim(),
                              firstName: _nameController.text.trim(),
                              gender: _gender,
                              dateOfBirth: _sportsman.dateOfBirth,
                              subscriptions: _sportsman.subscriptions));
                      if (success) {
                        _sportsman.firstName = _nameController.text.trim();
                        _sportsman.phone = _phoneController.text.trim();
                        _sportsman.gender = _gender;
                        _sportsmanDBService.put(_sportsman);
                      }
                      Navigator.pop(context);
                    }
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

  bool validateFields() {
    setState(() {
      _nameValidator.value = _nameController.text.isNotEmpty;
      _phoneValidator.value = _phoneController.text.isNotEmpty;
    });
    return _nameValidator.value && _phoneValidator.value;
  }
}
