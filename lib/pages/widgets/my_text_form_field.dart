import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final String? initialValue;
  final String? fieldName;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final bool? readOnly;
  final bool? autofocus;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final int? maxLength;
  final int? numberOfLines;

  const MyTextFormField(
      {this.initialValue,
      this.fieldName,
      this.fontSize,
      this.textAlign,
      this.keyboardType,
      this.obscureText,
      this.readOnly,
      this.autofocus,
      this.onSaved,
      this.validator,
      this.maxLength,
      this.numberOfLines,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 11),
      child: TextFormField(
        initialValue: initialValue,
        maxLength: maxLength ?? 255,
        style: TextStyle(
          fontSize: fontSize,
        ),
        decoration: InputDecoration(
          counterText: '',
          labelText: fieldName,
        ),
        autocorrect: false,
        textCapitalization: TextCapitalization.none,
        enableSuggestions: false,
        textAlign: textAlign ?? TextAlign.start,
        keyboardType: keyboardType,
        obscureText: obscureText ?? false,
        onSaved: onSaved,
        validator: validator,
        readOnly: readOnly ?? false,
        autofocus: autofocus ?? false,
        minLines: numberOfLines,
        maxLines: numberOfLines ?? 1,
      ),
    );
  }
}
