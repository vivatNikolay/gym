import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../widgets/image_selector.dart';
import '../../widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/circle_image.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/profile-edit';
  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  var _isInit = true;

  late Account _account;
  late ValueNotifier<bool> _nameValidator;
  late ValueNotifier<bool> _phoneValidator;
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;
  bool _saveEnabled = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _account = Provider.of<AccountPr>(context, listen: false).account!;
      _nameController.text = _account.firstName;
      _phoneController.text = _account.phone;
      _nameValidator = ValueNotifier(true);
      _phoneValidator = ValueNotifier(true);
      _gender = ValueNotifier(_account.gender);
      _iconNum = ValueNotifier(_account.iconNum);
    }
    _isInit = false;
    super.didChangeDependencies();
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
        title: const Text('Профиль'),
        actions: [
          AbsorbPointer(
            absorbing: !_saveEnabled,
            child: IconButton(
              padding: const EdgeInsets.only(right: 12),
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async {
                setState(() => _saveEnabled = false);
                ScaffoldMessenger.of(context).clearSnackBars();
                if (validateFields()) {
                  bool success = await Provider.of<AccountPr>(context, listen: false).put(
                      Account(
                          email: _account.email,
                          lastName: _account.lastName,
                          password: _account.password,
                          phone: _phoneController.text.trim(),
                          firstName: _nameController.text.trim(),
                          gender: _gender.value,
                          iconNum: _iconNum.value,
                          dateOfBirth: _account.dateOfBirth,
                          subscriptions: _account.subscriptions,
                          role: _account.role));
                  if (success) {
                    Navigator.of(context).pop();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Нет интернет соединения'),
                    ));
                  }
                }
                setState(() => _saveEnabled = true);
              },
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width / 10)
            .copyWith(top: 20),
        children: [
          CircleImage(
              image: AssetImage('images/profileImg${_iconNum.value}.png'),
              icon: Icons.edit,
              onTap: () async {
                await Navigator.of(context).push(
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
            fontSize: 20,
            fieldName: 'Имя',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          MyTextField(
            controller: _phoneController,
            validation: _phoneValidator,
            fontSize: 20,
            fieldName: 'Телефон',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          GenderSwitcher(
              gender: _gender,
              onPressedMale: () => setState(() => _gender.value = true),
              onPressedFemale: () => setState(() => _gender.value = false)),
        ],
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
