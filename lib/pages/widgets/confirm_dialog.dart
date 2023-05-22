import 'package:flutter/material.dart';

import '../../helpers/constants.dart';
import 'loading_buttons/loading_text_button.dart';

class ConfirmDialog extends StatelessWidget {
  final Future<void> Function() onYes;
  final String textConfirmation;

  const ConfirmDialog({
    this.textConfirmation = 'Вы уверены?',
    required this.onYes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение'),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(textConfirmation),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Нет',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        LoadingTextButton(
          onPressed: onYes,
          child: const Text('Да',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
    );
  }
}
