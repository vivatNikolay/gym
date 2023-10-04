import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';

import '../../../pages/widgets/my_text_field.dart';
import '../../../providers/account_provider.dart';
import '../../widgets/loading_buttons/loading_icon_button.dart';

class PasswordChanger extends StatefulWidget {
  static const routeName = '/password-changer';

  const PasswordChanger({Key? key}) : super(key: key);

  @override
  State<PasswordChanger> createState() => _PasswordChangerState();
}

class _PasswordChangerState extends State<PasswordChanger> {
  final TextEditingController _newPass1Controller = TextEditingController();
  final TextEditingController _newPass2Controller = TextEditingController();
  late ValueNotifier<bool> _newPass1Validator;
  late ValueNotifier<bool> _newPass2Validator;

  @override
  initState() {
    super.initState();

    _newPass1Validator = ValueNotifier(true);
    _newPass2Validator = ValueNotifier(true);
  }

  @override
  void dispose() {
    _newPass1Validator.dispose();
    _newPass2Validator.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('changingPassword'.i18n()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LoadingIconButton(
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async {
                ScaffoldMessenger.of(context).clearSnackBars();
                if (validateFields()) {
                  try {
                    await Provider.of<AccountPr>(context, listen: false)
                        .updatePass(_newPass2Controller.text);
                    Navigator.of(context).pop();
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(e.toString()),
                    ));
                  }
                }
              },
            ),
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: Theme.of(context).colorScheme.background,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: size.width * 0.1).copyWith(top: 30),
          children: [
            MyTextField(
              controller: _newPass1Controller,
              validation: _newPass1Validator,
              fieldName: 'newPassword'.i18n(),
              textAlign: TextAlign.center,
              fontSize: 18,
              obscureText: true,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _newPass2Controller,
              validation: _newPass2Validator,
              fieldName: 'repeatPassword'.i18n(),
              textAlign: TextAlign.center,
              fontSize: 18,
              obscureText: true,
              errorText: 'passwordIsNotSame'.i18n(),
            ),
          ],
        ),
      ),
    );
  }

  bool validateFields() {
    setState(() {
      _newPass1Validator.value = _newPass1Controller.text.isNotEmpty;
      _newPass2Validator.value = _newPass2Controller.text.isNotEmpty;
    });
    if (_newPass1Controller.text != _newPass2Controller.text) {
      _newPass2Validator.value = false;
    }
    return _newPass1Validator.value &&
        _newPass2Validator.value;
  }
}
