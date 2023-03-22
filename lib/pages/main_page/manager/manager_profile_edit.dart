import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../controllers/account_http_controller.dart';
import '../../../helpers/constants.dart';
import '../../widgets/image_selector.dart';
import '../../widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/my_text_field.dart';

class ManagerProfileEdit extends StatefulWidget {
  final Account account;
  final bool isEdit;

  const ManagerProfileEdit({required this.account, required this.isEdit, Key? key})
      : super(key: key);

  @override
  State<ManagerProfileEdit> createState() => _ManagerProfileEditState(account, isEdit);
}

class _ManagerProfileEditState extends State<ManagerProfileEdit> {
  final Account _account;
  final bool _isEdit;
  final AccountHttpController _accountHttpController = AccountHttpController.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late DateTime _pickedDate;
  late ValueNotifier<bool> _emailValidator;
  late ValueNotifier<bool> _nameValidator;
  late ValueNotifier<bool> _lastNameValidator;
  late ValueNotifier<bool> _phoneValidator;
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;
  final DateFormat formatterDate = DateFormat('dd.MM.yyyy');

  _ManagerProfileEditState(this._account, this._isEdit);

  @override
  void initState() {
    super.initState();

    _emailController.text = _account.email;
    _nameController.text = _account.firstName;
    _lastNameController.text = _account.lastName;
    _phoneController.text = _account.phone;
    _pickedDate = _account.dateOfBirth;
    _emailValidator = ValueNotifier(true);
    _nameValidator = ValueNotifier(true);
    _lastNameValidator = ValueNotifier(true);
    _phoneValidator = ValueNotifier(true);
    _gender = ValueNotifier(_account.gender);
    _iconNum = ValueNotifier(_account.iconNum);
  }

  @override
  void dispose() {
    _emailValidator.dispose();
    _nameValidator.dispose();
    _phoneValidator.dispose();
    _lastNameValidator.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check, size: 28),
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (validateFields()) {
                bool success;
                if (_isEdit) {
                  success = await _accountHttpController.editAccount(
                      Account(
                          email: _emailController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          password: _account.password,
                          phone: _phoneController.text.trim(),
                          firstName: _nameController.text.trim(),
                          gender: _gender.value,
                          iconNum: _iconNum.value,
                          dateOfBirth: _pickedDate,
                          subscriptions: _account.subscriptions,
                          role: _account.role));
                } else {
                  success = await _accountHttpController.createAccount(
                      Account(
                          email: _emailController.text.trim(),
                          lastName: _lastNameController.text.trim(),
                          password: '1111',
                          phone: _phoneController.text.trim(),
                          firstName: _nameController.text.trim(),
                          gender: _gender.value,
                          iconNum: _iconNum.value,
                          dateOfBirth: _pickedDate,
                          subscriptions: _account.subscriptions,
                          role: _account.role));
                }
                if (success) {
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Нет интернет соединения'),
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
              controller: _emailController,
              validation: _emailValidator,
              fontSize: 20,
              fieldName: 'Email',
              textAlign: TextAlign.center,
              readOnly: _isEdit,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _nameController,
              validation: _nameValidator,
              fontSize: 20,
              fieldName: 'Имя',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 5),
            MyTextField(
              controller: _lastNameController,
              validation: _nameValidator,
              fontSize: 20,
              fieldName: 'Фамилия',
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
            MyTextField(
              controller: TextEditingController()..text = formatterDate.format(_pickedDate),
              validation: ValueNotifier(true),
              fieldName: 'Дата рождения',
              textAlign: TextAlign.center,
              fontSize: 20,
              readOnly: true,
              onTap: () async {
                DateTime? newPickedDate = await showDatePicker(
                  context: context,
                  initialDate: _account.dateOfBirth,
                  firstDate: DateTime(1950),
                  lastDate: DateTime.now(),
                );
                if (newPickedDate != null) {
                  setState(() => _pickedDate = newPickedDate);
                }
              },
            ),
            const SizedBox(height: 5),
            GenderSwitcher(
                gender: _gender,
                onPressedMale: () => setState(() => _gender.value = true),
                onPressedFemale: () => setState(() => _gender.value = false)),
            const SizedBox(height: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: MediaQuery.of(context).size.width/7),
                backgroundColor: mainColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                ),
              ),
              onPressed: () {
                _account.password = '1111';
              },
              child: const Text(
                'Сбросить пароль',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool validateFields() {
    setState(() {
      _emailValidator.value = _emailController.text.isNotEmpty;
      _nameValidator.value = _nameController.text.isNotEmpty;
      _lastNameValidator.value = _lastNameController.text.isNotEmpty;
      _phoneValidator.value = _phoneController.text.isNotEmpty;
    });
    return _emailValidator.value &&
        _nameValidator.value &&
        _lastNameValidator.value &&
        _phoneValidator.value;
  }
}