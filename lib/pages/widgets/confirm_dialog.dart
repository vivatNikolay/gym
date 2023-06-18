import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../helpers/constants.dart';
import 'loading_buttons/loading_text_button.dart';

class ConfirmDialog extends StatelessWidget {
  final Future<void> Function() onYes;
  final String? textConfirmation;

  const ConfirmDialog({
    this.textConfirmation,
    required this.onYes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('confirmation'.i18n()),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(textConfirmation ?? 'areYouSure'.i18n()),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'no'.i18n(),
            style: const TextStyle(color: mainColor, fontSize: 18),
          ),
        ),
        LoadingTextButton(
          onPressed: onYes,
          child: Text(
            'yes'.i18n(),
            style: const TextStyle(color: mainColor, fontSize: 18),
          ),
        ),
      ],
    );
  }
}
