import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  late ValueNotifier<bool> validation;
  final String? errorText;
  final String? fieldName;
  bool obscureText;
  bool autofocus;
  double? fontSize;
  TextAlign? textAlign;
  bool readOnly;
  VoidCallback? onTap;

  MyTextField(
      {required this.controller,
      required this.validation,
      this.fieldName,
      this.errorText,
      this.obscureText = false,
      this.autofocus = false,
      this.fontSize,
      this.textAlign,
      this.readOnly = false,
      this.onTap,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: TextField(
        maxLength: 255,
        controller: controller,
        style: TextStyle(
          fontSize: fontSize,
        ),
        textAlign: textAlign ?? TextAlign.start,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          counterText: '',
          errorText: validation.value
              ? null
              : controller.text.isEmpty
                  ? 'Поле пустое'
                  : errorText,
          labelText: fieldName,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(15.0)),
          ),
        ),
        obscureText: obscureText,
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
