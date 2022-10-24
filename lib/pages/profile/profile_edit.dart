import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/controllers/db_controller.dart';
import 'package:sportmen_in_gym/models/sportsman.dart';

import '../../controllers/http_controller.dart';
import '../../helpers/constants.dart';
import '../widgets/my_text_field.dart';

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
  late ValueNotifier<bool> _nameValidator;
  final List<String> _dropdownItems = ['male', 'female'];
  late String _dropdownValue;

  _ProfileEditState(this.sportsman);

  @override
  void initState() {
    super.initState();

    _nameController.text = sportsman.firstName;
    _phoneController.text = sportsman.phone;
    _nameValidator = ValueNotifier(true);
    _dropdownValue = sportsman.gender ? _dropdownItems[0] : _dropdownItems[1];
  }

  @override
  void dispose() {
    _nameValidator.dispose();

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
                        width: 60,
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
                Row(
                  children: [
                    const SizedBox(
                      width: 60,
                      child: Text('Phone:', style: TextStyle(fontSize: 16))
                    ),
                    Flexible(
                      child: TextField(
                        style: const TextStyle(
                          fontSize: 18,
                        ),
                        controller: _phoneController,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                        width: 60,
                        child: Text('Gender:', style: TextStyle(fontSize: 16))
                    ),
                    DropdownButton(
                      elevation: 2,
                      value: _dropdownValue,
                      items: _dropdownItems.map((String item) {
                        return DropdownMenuItem(
                          value: item,
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropdownValue = newValue!;
                          sportsman.gender = newValue == 'male';
                        });
                      },
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
                        sportsman.firstName = _nameController.text.trim();
                        sportsman.phone = _phoneController.text.trim();
                        bool success = await _httpController.putSportsman(
                            sportsman);
                        if (success) {
                          _dbController.saveOrUpdateSportsman(sportsman);
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
    setState(() => _nameValidator.value = _nameController.text.isNotEmpty);
    return _nameValidator.value;
  }
}
