import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../helpers/constants.dart';
import '../../../http/account_http_service.dart';
import '../../../providers/account_provider.dart';
import '../../widgets/image_selector.dart';
import '../../widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/loading_buttons/loading_elevated_button.dart';
import '../../widgets/loading_buttons/loading_icon_button.dart';
import '../../widgets/my_text_field.dart';
import '../../widgets/my_text_form_field.dart';

class ManagerProfileEdit extends StatefulWidget {
  final Account? account;

  const ManagerProfileEdit({this.account, Key? key}) : super(key: key);

  @override
  State<ManagerProfileEdit> createState() => _ManagerProfileEditState();
}

class _ManagerProfileEditState extends State<ManagerProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  final DateFormat formatterDate = DateFormat('dd.MM.yyyy');
  final RegExp _regExpEmail = RegExp(
      r"^[\w\.\%\+\-\_\#\!\?\$\&\'\*\/\=\^\{\|\`]+@[A-z0-9\.\-]+\.[A-z]{2,}$",
      multiLine: false);
  bool _isInit = true;
  late Account _managerAcc;
  late Account _account;
  late bool _isEdit;
  final AccountHttpService _httpService = AccountHttpService();
  String _id = DateTime.now().millisecondsSinceEpoch.toString();
  String _email = '';
  String _name = '';
  String _lastName = '';
  String _phone = '';
  DateTime _pickedDate = DateTime.utc(2000);
  ValueNotifier<bool> _gender = ValueNotifier(true);
  ValueNotifier<int> _iconNum = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    _isEdit = widget.account != null;
    if (_isEdit) {
      _account = widget.account!;

      _id = _account.id;
      _email = _account.email;
      _name = _account.firstName;
      _lastName = _account.lastName;
      _phone = _account.phone;
      _pickedDate = _account.dateOfBirth;
      _gender = ValueNotifier(_account.gender);
      _iconNum = ValueNotifier(_account.iconNum);
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _managerAcc = Provider.of<AccountPr>(context, listen: false).account!;
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _trySubmit() async {
    ScaffoldMessenger.of(context).clearSnackBars();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        if (_isEdit) {
          await _httpService.edit(
              _managerAcc,
              Account(
                  id: _id,
                  email: _email,
                  lastName: _lastName,
                  password: _account.password,
                  phone: _phone,
                  firstName: _name,
                  gender: _gender.value,
                  iconNum: _iconNum.value,
                  dateOfBirth: _pickedDate,
                  role: _account.role));
        } else {
          await _httpService.create(
              _managerAcc,
              Account(
                  id: _id,
                  email: _email,
                  lastName: _lastName,
                  password: '1111',
                  phone: _phone,
                  firstName: _name,
                  gender: _gender.value,
                  iconNum: _iconNum.value,
                  dateOfBirth: _pickedDate,
                  role: 'USER'));
        }
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Профиль'),
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
          padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 10)
              .copyWith(top: 20),
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
              fieldName: 'Email',
              textAlign: TextAlign.center,
              readOnly: _isEdit,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Поле пустое';
                } else if (_regExpEmail.hasMatch(value.trim())) {
                  return null;
                } else {
                  return 'Неверный email';
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
              initialValue: _name,
              fieldName: 'Имя',
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'Поле пустое';
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
              fieldName: 'Фамилия',
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'Поле пустое';
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
              fieldName: 'Телефон',
              fontSize: 20,
              textAlign: TextAlign.center,
              validator: (value) {
                if (value != null && value.isNotEmpty) {
                  return null;
                }
                return 'Поле пустое';
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
              fieldName: 'Дата рождения',
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
            if (_isEdit) _resetPassword(_managerAcc),
          ],
        ),
      ),
    );
  }

  Widget _resetPassword(Account managerAcc) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: LoadingElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(
              vertical: 15, horizontal: MediaQuery.of(context).size.width / 7),
          backgroundColor: mainColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(30),
            ),
          ),
        ),
        onPressed: () async {
          try {
            await _httpService.edit(
                managerAcc,
                Account(
                    id: _id,
                    email: _account.email,
                    lastName: _account.lastName,
                    password: '1111',
                    phone: _account.phone,
                    firstName: _account.firstName,
                    gender: _account.gender,
                    iconNum: _account.iconNum,
                    dateOfBirth: _account.dateOfBirth,
                    role: _account.role));
            Navigator.of(context).pop();
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(e.toString()),
            ));
          }
        },
        child: const Text(
          'Сбросить пароль',
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
