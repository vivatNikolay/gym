import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/login/widgets/login_button.dart';
import '../../helpers/constants.dart';
import '../../providers/account_provider.dart';
import '../widgets/my_text_form_field.dart';
import 'widgets/field_name.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final RegExp _regExpEmail = RegExp(
      r"^[\w\.\%\+\-\_\#\!\?\$\&\'\*\/\=\^\{\|\`]+@[A-z0-9\.\-]+\.[A-z]{2,}$",
      multiLine: false);
  bool _isLoading = false;
  String _email = '';
  String _password = '';
  String _errorMess = '';

  void _trySubmit() async {
    setState(() {
      _isLoading = true;
    });
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();
      try {
        _errorMess = '';
        await Provider.of<AccountPr>(context, listen: false)
            .login(_email.trim(), _password);
      } catch (e) {
        _errorMess = e.toString();
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(40, 120, 40, 10),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Text(
                  'Добро пожаловать',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'PT-Sans',
                    fontSize: 46,
                    fontWeight: FontWeight.bold,
                    color: mainColor,
                  ),
                ),
                const SizedBox(
                  height: 45,
                ),
                const FieldName(text: 'Логин'),
                MyTextFormField(
                  validator: (value) {
                    if (value != null && _regExpEmail.hasMatch(value.trim())) {
                      return null;
                    }
                    return 'Неверный логин';
                  },
                  keyboardType: TextInputType.emailAddress,
                  onSaved: (value) {
                    if (value != null) {
                      _email = value.trim();
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                const FieldName(text: 'Пароль'),
                MyTextFormField(
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return null;
                    }
                    return 'Неверный пароль';
                  },
                  obscureText: true,
                  onSaved: (value) {
                    if (value != null) {
                      _password = value.trim();
                    }
                  },
                ),
                const SizedBox(
                  height: 15,
                ),
                _isLoading
                    ? const CircularProgressIndicator()
                    : LoginButton(
                        onPressed: _trySubmit,
                      ),
                Text(_errorMess),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
