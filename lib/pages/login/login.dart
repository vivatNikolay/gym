import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../pages/login/widgets/login_button.dart';
import '../../helpers/constants.dart';
import '../../providers/account_provider.dart';
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
            .get(_email.trim(), _password);
      } on SocketException {
        _errorMess = 'Нет интернет соединения';
      } catch (e) {
        _errorMess = 'Неверный логин или пароль';
      }
    }
    setState(() {
      _isLoading = false;
    });
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: const InputDecoration(
                      counterText: '',
                    ),
                    autocorrect: false,
                    textCapitalization: TextCapitalization.none,
                    enableSuggestions: false,
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
                ),
                const SizedBox(
                  height: 15,
                ),
                const FieldName(text: 'Пароль'),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 11),
                  child: TextFormField(
                    maxLength: 255,
                    decoration: const InputDecoration(
                      counterText: '',
                    ),
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
                ),
                const SizedBox(
                  height: 15,
                ),
                if (_isLoading) const CircularProgressIndicator(),
                if (!_isLoading)
                LoginButton(
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
