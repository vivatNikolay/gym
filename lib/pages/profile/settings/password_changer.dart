import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../pages/widgets/my_text_field.dart';
import '../../../models/account.dart';
import '../../../providers/account_provider.dart';

class PasswordChanger extends StatefulWidget {
  static const routeName = '/password-changer';

  const PasswordChanger({Key? key}) : super(key: key);

  @override
  State<PasswordChanger> createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  final TextEditingController _oldPassController = TextEditingController();
  final TextEditingController _newPass1Controller = TextEditingController();
  final TextEditingController _newPass2Controller = TextEditingController();
  late ValueNotifier<bool> _oldPassValidator;
  late ValueNotifier<bool> _newPass1Validator;
  late ValueNotifier<bool> _newPass2Validator;
  bool _saveEnabled = true;

  @override
  initState() {
    super.initState();

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
    final account = Provider.of<AccountPr>(context, listen: false).account!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Смена пароля'),
        actions: [
          AbsorbPointer(
            absorbing: !_saveEnabled,
            child: IconButton(
              padding: const EdgeInsets.only(right: 12),
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async {
                setState(() => _saveEnabled = false);
                ScaffoldMessenger.of(context).clearSnackBars();
                if (validateFields(account)) {
                  try {
                    await Provider.of<AccountPr>(context, listen: false).put(
                        Account(
                            id: account.id,
                            email: account.email,
                            lastName: account.lastName,
                            password: _newPass2Controller.text,
                            phone: account.phone,
                            firstName: account.firstName,
                            gender: account.gender,
                            iconNum: account.iconNum,
                            dateOfBirth: account.dateOfBirth,
                            subscriptions: account.subscriptions,
                            role: account.role));
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                }
                setState(() => _saveEnabled = true);
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).backgroundColor,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(30, 30, 30, 0),
          children: [
            MyTextField(
              controller: _oldPassController,
              validation: _oldPassValidator,
              fieldName: 'Старый пароль',
              textAlign: TextAlign.center,
              fontSize: 18,
              obscureText: true,
              errorText: 'Неверный пароль',
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
    );
  }

  bool validateFields(Account acc) {
    setState(() {
      _oldPassValidator.value = _oldPassController.text.isNotEmpty;
      _newPass1Validator.value = _newPass1Controller.text.isNotEmpty;
      _newPass2Validator.value = _newPass2Controller.text.isNotEmpty;
    });
    if (_oldPassController.text != acc.password) {
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
