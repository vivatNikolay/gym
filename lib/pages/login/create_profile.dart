import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localization/localization.dart';

import '../../../services/account_fire.dart';
import '../../../models/account.dart';
import '../widgets/circle_image.dart';
import '../widgets/gender_switcher.dart';
import '../widgets/image_selector.dart';
import '../widgets/loading_buttons/loading_icon_button.dart';
import '../widgets/my_text_field.dart';
import '../widgets/my_text_form_field.dart';

class CreateProfile extends StatefulWidget {
  final Account? account;

  const CreateProfile({this.account, Key? key}) : super(key: key);

  @override
  State<CreateProfile> createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  final AccountFire _accountFire = AccountFire();
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  final RegExp _regExpEmail = RegExp(
      r"^[\w.%+\-_#!?$&'*/=^{|`]+@[A-z0-9.\-]+\.[A-z]{2,}$",
      multiLine: false);
  String _email = '';
  String _password = '';
  String _name = '';
  String _lastName = '';
  String _phone = '';
  DateTime _pickedDate = DateTime.utc(2000);
  final ValueNotifier<bool> _gender = ValueNotifier(true);
  final ValueNotifier<int> _iconNum = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
  }

  void _trySubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        String? id = await _accountFire.signup(_email, _password);
        await _accountFire.create(
            Account(
                id: id,
                email: _email,
                lastName: _lastName,
                phone: _phone,
                firstName: _name,
                gender: _gender.value,
                iconNum: _iconNum.value,
                dateOfBirth: _pickedDate,
                role: 'USER'));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isWideScreen = size.width > 800;
    return Scaffold(
      appBar: AppBar(
        title: Text('profile'.i18n()),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: LoadingIconButton(
              icon: const Icon(Icons.check, size: 28),
              onPressed: () async => _trySubmit(),
            ),
          )
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: isWideScreen ? size.width * 0.25 : size.width * 0.1).copyWith(top: 20),
          children: [
            CircleImage(
                image: AssetImage('images/profileImg${_iconNum.value}.png'),
                icon: Icons.edit,
                onTap: () async {
                  await Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ImageSelector(iconNum: _iconNum)));
                  setState(() {
                    _iconNum.value;
                  });
                }),
            const SizedBox(height: 10),
            MyTextFormField(
              initialValue: _email,
              fontSize: 20,
              fieldName: 'email'.i18n(),
              textAlign: TextAlign.center,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'emptyField'.i18n();
                } else if (_regExpEmail.hasMatch(value.trim())) {
                  return null;
                } else {
                  return 'incorrectEmail'.i18n();
                }
              },
              keyboardType: TextInputType.emailAddress,
              onSaved: (value) {
                if (value != null) {
                  _email = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _password,
              fontSize: 20,
              fieldName: 'password'.i18n(),
              textAlign: TextAlign.center,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'emptyField'.i18n();
                }
                return null;
              },
              obscureText: true,
              onSaved: (value) {
                if (value != null) {
                  _password = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _name,
              fieldName: 'name'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.text,
              onSaved: (value) {
                if (value != null) {
                  _name = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _lastName,
              fieldName: 'lastName'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.text,
              onSaved: (value) {
                if (value != null) {
                  _lastName = value.trim();
                }
              },
            ),
            const SizedBox(height: 5),
            MyTextFormField(
              initialValue: _phone,
              fieldName: 'phone'.i18n(),
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'emptyField'.i18n();
              },
              keyboardType: TextInputType.phone,
              onSaved: (value) {
                if (value != null) {
                  _phone = value.trim();
                }
              },
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: TextEditingController()
                ..text = formatterDate.format(_pickedDate),
              validation: ValueNotifier(true),
              fieldName: 'dateOfBirth'.i18n(),
              textAlign: TextAlign.center,
              fontSize: 20,
              readOnly: true,
              onTap: () async {
                DateTime? newPickedDate = await showDatePicker(
                  context: context,
                  initialDate: _pickedDate,
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
              onPressedFemale: () => setState(() => _gender.value = false),
            ),
          ],
        ),
      ),
    );
  }
}
