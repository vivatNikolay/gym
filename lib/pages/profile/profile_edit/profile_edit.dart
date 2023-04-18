import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/account_provider.dart';
import '../../widgets/image_selector.dart';
import '../../widgets/gender_switcher.dart';
import '../../../models/account.dart';
import '../../widgets/circle_image.dart';
import '../../widgets/my_text_form_field.dart';

class ProfileEdit extends StatefulWidget {
  static const routeName = '/profile-edit';

  const ProfileEdit({Key? key}) : super(key: key);

  @override
  State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();
  bool _isInit = true;

  late Account _account;
  String _name = '';
  String _phone = '';
  late ValueNotifier<bool> _gender;
  late ValueNotifier<int> _iconNum;
  bool _saveEnabled = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _account = Provider.of<AccountPr>(context, listen: false).account!;
      _name = _account.firstName;
      _phone = _account.phone;
      _gender = ValueNotifier(_account.gender);
      _iconNum = ValueNotifier(_account.iconNum);
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  void _trySubmit() async {
    setState(() => _saveEnabled = false);
    ScaffoldMessenger.of(context).clearSnackBars();
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState!.save();
      try {
        await Provider.of<AccountPr>(context, listen: false).put(Account(
            email: _account.email,
            lastName: _account.lastName,
            password: _account.password,
            phone: _phone,
            firstName: _name,
            gender: _gender.value,
            iconNum: _iconNum.value,
            dateOfBirth: _account.dateOfBirth,
            subscriptions: _account.subscriptions,
            role: _account.role));
        Navigator.of(context).pop();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(e.toString()),
        ));
      }
    }
    setState(() => _saveEnabled = true);
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
              onPressed: _trySubmit,
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
            GenderSwitcher(
                gender: _gender,
                onPressedMale: () => setState(() => _gender.value = true),
                onPressedFemale: () => setState(() => _gender.value = false)),
          ],
        ),
      ),
    );
  }
}
