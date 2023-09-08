import 'dart:io';

import 'package:flutter/material.dart';

class SettingTitle extends StatelessWidget {
  final String text;

  const SettingTitle({required this.text, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isIOS = false;
    try {
      isIOS = Platform.isIOS;
    } catch (e) {
      print('web');
    }
    return Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.fromLTRB(6, 4, 0, 0),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 17,
              fontStyle: isIOS ? FontStyle.normal : FontStyle.italic),
        )
    );
  }
}
