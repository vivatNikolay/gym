import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class ConfirmDialog extends StatelessWidget {
  final VoidCallback onNo;
  final VoidCallback onYes;
  final String textConfirmation;

  const ConfirmDialog(
      {this.textConfirmation = 'Are you sure?',
      required this.onNo,
      required this.onYes,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirmation'),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      content: Text(textConfirmation),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: onNo,
          child: const Text('No',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: onYes,
          child: const Text('Yes',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
    );
  }
}
