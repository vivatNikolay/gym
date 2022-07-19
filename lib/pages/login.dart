import 'package:flutter/material.dart';

import '../controllers/http_controller.dart';
import '../controllers/db_controller.dart';
import '../models/sportsman.dart';
import 'widgets/field_name.dart';
import 'home.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final HttpController _httpController = HttpController.instance;
  final DBController _dbController = DBController.instance;
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  Future<Sportsman>? _futureSportsman;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 40,
              ).copyWith(top: 90),
              child: Column(
                children: [
                  const Text(
                    'Welcome',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'PT-Sans',
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  const FieldName(text: 'Login'),
                  TextField(
                    controller: _loginController,
                    cursorColor: Colors.deepOrangeAccent,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepOrangeAccent)),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const FieldName(text: 'Password'),
                  TextField(
                    controller: _passController,
                    cursorColor: Colors.deepOrangeAccent,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.deepOrangeAccent)),
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 50,
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.black12,
                        side: const BorderSide(
                            color: Colors.deepOrangeAccent, width: 1),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () => setState(() {
                        _futureSportsman = _httpController.getSportsman(
                            _loginController.text, _passController.text);
                      }),
                      child: const Text(
                        'Log in',
                        style: TextStyle(
                          color: Colors.deepOrangeAccent,
                          fontSize: 19,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  FutureBuilder<Sportsman>(
                      future: _futureSportsman,
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Container();
                          case ConnectionState.waiting:
                            return const CircularProgressIndicator(
                                color: Colors.deepOrangeAccent);
                          default:
                            if (snapshot.hasError) {
                              throw snapshot.error!;
                            }
                            if (snapshot.hasData) {
                              print('hasData');
                              _dbController.addSportsman(snapshot.data!);
                              WidgetsBinding.instance
                                  ?.addPostFrameCallback((_) {
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) => const Home()));
                              }); //Сначала переход на страницу, а потом рисую, видимо это ошибка
                              return const Icon(Icons.check, color: Colors.deepOrangeAccent, size: 24);
                            } else {
                              return const Text('not found');
                            }
                        }
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
