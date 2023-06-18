import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValueNotifier<bool> validation;
  final String? errorText;
  final String? fieldName;
  final bool obscureText;
  final bool autofocus;
  final double? fontSize;
  final TextAlign? textAlign;
  final bool readOnly;
  final VoidCallback? onTap;

  const MyTextField(
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
          counterText: '',
          errorText: validation.value
              ? null
              : controller.text.isEmpty
                  ? 'emptyField'.i18n()
                  : errorText,
          labelText: fieldName,
        ),
        obscureText: obscureText,
        autofocus: autofocus,
        readOnly: readOnly,
        onTap: onTap,
      ),
    );
  }
}
