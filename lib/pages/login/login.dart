import 'dart:io';
import 'package:flutter/material.dart';

import '../../controllers/account_http_controller.dart';
import '../../pages/login/widgets/login_button.dart';
import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../../services/db/account_db_service.dart';
import '../widgets/my_text_field.dart';
import 'widgets/field_name.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AccountHttpController _accountHttpController =
      AccountHttpController.instance;
  final AccountDBService _accountDBService = AccountDBService();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  late ValueNotifier<bool> _loginValidation;
  late ValueNotifier<bool> _passwordValidation;
  Future<Account>? _futureAccount;
  final RegExp _regExpEmail = RegExp(
      r"^[\w\.\%\+\-\_\#\!\?\$\&\'\*\/\=\^\{\|\`]+@[A-z0-9\.\-]+\.[A-z]{2,}$",
      multiLine: false);
  bool _loginEnabled = true;

  @override
  void initState() {
    super.initState();

    _loginValidation = ValueNotifier(true);
    _passwordValidation = ValueNotifier(true);
  }

  @override
  void dispose() {
    _loginValidation.dispose();
    _passwordValidation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
              horizontal: 40,
            ).copyWith(top: 90),
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
                MyTextField(
                  controller: _loginController,
                  validation: _loginValidation,
                  errorText: 'Неверный логин',
                ),
                const SizedBox(
                  height: 15,
                ),
                const FieldName(text: 'Пароль'),
                MyTextField(
                  controller: _passController,
                  validation: _passwordValidation,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                AbsorbPointer(
                  absorbing: !_loginEnabled,
                  child: LoginButton(
                    onPressed: () => setState(() {
                      _loginEnabled = false;
                      if (validateFields()) {
                        _futureAccount = _accountHttpController.getAccount(
                            _loginController.text.trim(), _passController.text);
                      }
                      _loginEnabled = true;
                    }),
                  ),
                ),
                FutureBuilder<Account>(
                    future: _futureAccount,
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Container();
                        case ConnectionState.waiting:
                          return const CircularProgressIndicator(
                              color: mainColor);
                        default:
                          if (snapshot.hasError) {
                            if (snapshot.error! is SocketException) {
                              return const Text('Нет интернет соединения');
                            }
                            return const Text('Неверный логин или пароль');
                          }
                          if (snapshot.hasData) {
                            _accountDBService.put(snapshot.data!);
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              Navigator.pushReplacementNamed(context, 'home');
                            });
                            return const Icon(Icons.check,
                                color: mainColor, size: 24);
                          } else {
                            return const Text('Неверный логин или пароль');
                          }
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validateFields() {
    _loginValidation.value =
        _regExpEmail.hasMatch(_loginController.text.trim());
    _passwordValidation.value = _passController.text.isNotEmpty;
    return _loginValidation.value && _passwordValidation.value;
  }
}
