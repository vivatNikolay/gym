import 'package:flutter/material.dart';

import '../../../controllers/account_http_controller.dart';
import '../../../pages/widgets/my_text_field.dart';
import '../../../models/account.dart';
import '../../../services/db/account_db_service.dart';

class PasswordChanger extends StatefulWidget {
  const PasswordChanger({Key? key}) : super(key: key);

  @override
  State<PasswordChanger> createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  late Account _account;
  final AccountHttpController _accountHttpController = AccountHttpController.instance;
  final AccountDBService _accountDBService = AccountDBService();
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPass1Controller = TextEditingController();
  final TextEditingController _newPass2Controller = TextEditingController();
  late ValueNotifier<bool> _oldPassValidator;
  late ValueNotifier<bool> _newPass1Validator;
  late ValueNotifier<bool> _newPass2Validator;

  @override
  initState() {
    super.initState();

    _account = _accountDBService.getFirst()!;
    _oldPassValidator = ValueNotifier(true);
    _newPass1Validator = ValueNotifier(true);
    _newPass2Validator = ValueNotifier(true);
  }

  @override
  void dispose() {
    _oldPassValidator.dispose();
    _newPass1Validator.dispose();
    _newPass2Validator.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена пароля'),
        actions: [
          IconButton(
            padding: const EdgeInsets.only(right: 12),
            icon: const Icon(Icons.check, size: 28),
            onPressed: () async {
              ScaffoldMessenger.of(context).clearSnackBars();
              if (validateFields()) {
                bool success = await _accountHttpController.editOwnAccount(Account(
                    email: _account.email,
                    lastName: _account.lastName,
                    password: _newPass2Controller.text,
                    phone: _account.phone,
                    firstName: _account.firstName,
                    gender: _account.gender,
                    iconNum: _account.iconNum,
                    dateOfBirth: _account.dateOfBirth,
                    subscriptions: _account.subscriptions,
                    role: _account.role));
                if (success) {
                  _account.password = _newPass2Controller.text;
                  _accountDBService.put(_account);
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Нет интернет соединения'),
                  ));
                }
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          child: Column(
            children: [
              MyTextField(
                controller: _oldPassController,
                validation: _oldPassValidator,
                fieldName: 'Старый пароль',
                textAlign: TextAlign.center,
                fontSize: 18,
                obscureText: true,
                errorText: 'Некоректный пароль',
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _newPass1Controller,
                validation: _newPass1Validator,
                fieldName: 'Новый пароль',
                textAlign: TextAlign.center,
                fontSize: 18,
                obscureText: true,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: _newPass2Controller,
                validation: _newPass2Validator,
                fieldName: 'Повтор пароля',
                textAlign: TextAlign.center,
                fontSize: 18,
                obscureText: true,
                errorText: 'Повтор не совпадает',
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    setState(() {
      _oldPassValidator.value = _oldPassController.text.isNotEmpty;
      _newPass1Validator.value = _newPass1Controller.text.isNotEmpty;
      _newPass2Validator.value = _newPass2Controller.text.isNotEmpty;
    });
    if (_oldPassController.text != _account.password) {
      _oldPassValidator.value = false;
    }
    if (_newPass1Controller.text != _newPass2Controller.text) {
      _newPass2Validator.value = false;
    }
    return _oldPassValidator.value &&
        _newPass1Validator.value &&
        _newPass2Validator.value;
  }
}
