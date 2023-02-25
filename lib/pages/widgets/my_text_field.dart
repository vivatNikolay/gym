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
  bool inBox;
  bool readOnly;

  MyTextField({
    required this.controller,
    required this.validation,
    this.inBox = false,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.autofocus = false,
    this.fontSize,
    this.textAlign,
    this.readOnly = false,
    Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: inBox ? BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(15.0)),
        color: Theme.of(context).primaryColor,
      ) : null,
      child: TextField(
        maxLength: 255,
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
        ),
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 5),
          enabledBorder: inBox ? InputBorder.none : null,
          counterText: '',
          hintText: hintText,
          errorText: validation.value ? null
              : controller.text.isEmpty
                ? 'Поле пустое'
                : errorText,
        ),
        obscureText: obscureText,
        autofocus: autofocus,
        readOnly: readOnly,
      ),
    );
  }
}
