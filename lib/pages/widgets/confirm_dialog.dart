import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;
  final String textConfirmation;

  const ConfirmDialog(
      {this.textConfirmation = 'Вы уверены?',
      required this.onNo,
      required this.onYes,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение'),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      content: Text(textConfirmation),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: onNo,
          child: const Text('Нет',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: onYes,
          child: const Text('Да',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
    );
  }
}
