import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  late ValueNotifier<bool> validation;
  final String? errorText;
  final String? hintText;
  bool obscureText;
  bool autofocus;
  double? fontSize;
  TextAlign? textAlign;

  MyTextField({
    required this.controller,
    required this.validation,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.autofocus = false,
    this.fontSize,
    this.textAlign,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLength: 255,
      controller: controller,
      style: TextStyle(
        fontSize: fontSize,
      ),
      textAlign: textAlign ?? TextAlign.start,
      decoration: InputDecoration(
        counterText: '',
        hintText: hintText,
        errorText: validation.value ? null
            : controller.text.isEmpty
              ? 'Field is empty'
              : errorText,
      ),
      obscureText: obscureText,
      autofocus: autofocus,
    );
  }
}
