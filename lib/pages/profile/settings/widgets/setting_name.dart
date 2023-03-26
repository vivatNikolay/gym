import 'package:flutter/material.dart';

class SettingName extends StatelessWidget {
  final String text;

  const SettingName({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 8),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 15),
        )
    );
  }
}
