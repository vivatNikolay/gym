import 'package:flutter/material.dart';

import '../../../helpers/constants.dart';

class AuthenticationField extends StatelessWidget {
  final TextEditingController controller;
  late ValueNotifier<bool> validation;
  final String? errorText;
  bool obscureText;

  AuthenticationField({
    required this.controller,
    required this.validation,
    this.errorText,
    this.obscureText = false,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: mainColor)),
        errorText: validation.value ? null
            : controller.text.isEmpty
              ? 'Field is empty'
              : errorText,
      ),
      obscureText: obscureText,
      maxLength: 300,
    );
  }
}
