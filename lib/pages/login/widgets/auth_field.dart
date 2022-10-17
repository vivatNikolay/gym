import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController controller;
  late ValueNotifier<bool> validation;
  final String? errorText;
  bool obscureText;

  AuthField({
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
        errorText: validation.value ? null
            : controller.text.isEmpty
              ? 'Field is empty'
              : errorText,
      ),
      obscureText: obscureText,
    );
  }
}
