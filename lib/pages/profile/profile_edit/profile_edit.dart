import 'package:flutter/material.dart';

import '../../../controllers/account_http_controller.dart';
import '../../../pages/profile/profile_edit/image_selector.dart';
import '../../../pages/profile/profile_edit/widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../../services/db/account_db_service.dart';
import '../../widgets/my_text_field.dart';
import '../widgets/circle_image.dart';

class ProfileEdit extends StatefulWidget {
  final Account account;
  ProfileEdit({required this.account, Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState(account);
}

class _ProfileEditState extends State<ProfileEdit> {
  Account _account;
  final AccountHttpController _accountHttpController = AccountHttpController.instance;
  final AccountDBService _accountDBService = AccountDBService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late ValueNotifier<bool> _nameValidator;
  late ValueNotifier<bool> _phoneValidator;
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;

  _ProfileEditState(this._account);

  @override
  void initState() {
    super.initState();

    _nameController.text = _account.firstName;
    _phoneController.text = _account.phone;
    _nameValidator = ValueNotifier(true);
    _phoneValidator = ValueNotifier(true);
    _gender = ValueNotifier(_account.gender);
    _iconNum = ValueNotifier(_account.iconNum);
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
                bool success = await _accountHttpController.putAccount(Account(
                    id: _account.id,
                    email: _account.email,
                    password: _account.password,
                    phone: _phoneController.text.trim(),
                    firstName: _nameController.text.trim(),
                    gender: _gender.value,
                    iconNum: _iconNum.value,
                    dateOfBirth: _account.dateOfBirth,
                    subscriptions: _account.subscriptions,
                    role: _account.role));
                if (success) {
                  _account.firstName = _nameController.text.trim();
                  _account.phone = _phoneController.text.trim();
                  _account.gender = _gender.value;
                  _account.iconNum = _iconNum.value;
                  _accountDBService.put(_account);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('No connection'),
                  ));
                }
              }
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width/10).copyWith(top: 20),
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
              inBox: false,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _phoneController,
              validation: _phoneValidator,
              fontSize: 20,
              hintText: 'Phone',
              textAlign: TextAlign.center,
              inBox: false,
            ),
            const SizedBox(height: 10),
            GenderSwitcher(
                gender: _gender,
                onPressedMale: () => setState(() => _gender.value = true),
                onPressedFemale: () => setState(() => _gender.value = false)),
          ],
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
