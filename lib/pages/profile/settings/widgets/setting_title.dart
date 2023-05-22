import 'package:flutter/material.dart';

class SettingTitle extends StatelessWidget {
  String text;

  SettingTitle({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(6, 4, 0, 0),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 17,
              fontStyle: FontStyle.italic),
        )
    );
  }
}
