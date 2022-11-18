import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/pages/profile/profile_edit/image_selector.dart';
import 'package:sportmen_in_gym/pages/profile/profile_edit/widgets/gender_switcher.dart';

import '../../../models/sportsman.dart';
import '../../../controllers/http_controller.dart';
import '../../../services/db/sportsman_db_service.dart';
import '../../widgets/my_text_field.dart';
import '../widgets/circle_image.dart';

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
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;

  _ProfileEditState();

  @override
  void initState() {
    super.initState();

    _sportsman = _sportsmanDBService.getFirst()!;
    _nameController.text = _sportsman.firstName;
    _phoneController.text = _sportsman.phone;
    _nameValidator = ValueNotifier(true);
    _phoneValidator = ValueNotifier(true);
    _gender = ValueNotifier(_sportsman.gender);
    _iconNum = ValueNotifier(_sportsman.iconNum);
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
        actions: [
          IconButton(
              padding: const EdgeInsets.only(right: 12),
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async {
                ScaffoldMessenger.of(context).clearSnackBars();
                if (validateFields()) {
                  bool success = await _httpController.putSportsman(
                      Sportsman(
                          id: _sportsman.id,
                          email: _sportsman.email,
                          password: _sportsman.password,
                          phone: _phoneController.text.trim(),
                          firstName: _nameController.text.trim(),
                          gender: _gender.value,
                          iconNum: _iconNum.value,
                          dateOfBirth: _sportsman.dateOfBirth,
                          subscriptions: _sportsman.subscriptions));
                  if (success) {
                    _sportsman.firstName = _nameController.text.trim();
                    _sportsman.phone = _phoneController.text.trim();
                    _sportsman.gender = _gender.value;
                    _sportsman.iconNum = _iconNum.value;
                    _sportsmanDBService.put(_sportsman);
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                      content: Text('No connection'),
                    ));
                  }
                }
              },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50).copyWith(top: 20),
          child: Column(
            children: [
              CircleImage(
                  image: AssetImage('images/profileImg${_iconNum.value}.png'),
                  icon: Icons.edit,
                  onTap: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            ImageSelector(iconNum: _iconNum)));
                    setState(() {
                      _iconNum.value;
                    });
                  }),
              const SizedBox(height: 10),
              MyTextField(
                controller: _nameController,
                validation: _nameValidator,
                fontSize: 21,
                hintText: 'Name',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 5),
              MyTextField(
                controller: _phoneController,
                validation: _phoneValidator,
                fontSize: 20,
                hintText: 'Phone',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              GenderSwitcher(
                  gender: _gender,
                  onPressedMale: () => setState(() => _gender.value = true),
                  onPressedFemale: () => setState(() => _gender.value = false)
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
