import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class ConfirmDialog extends StatefulWidget {
  final Future<void> Function() onYes;
  final String textConfirmation;

  const ConfirmDialog({
    this.textConfirmation = 'Вы уверены?',
    required this.onYes,
    Key? key,
  }) : super(key: key);

  @override
  State<ConfirmDialog> createState() => _ConfirmDialogState();
}

class _ConfirmDialogState extends State<ConfirmDialog> {
  bool _isLoading = false;

  Future<void> _yesAction() async {
    setState(() {
      _isLoading = true;
    });
    await widget.onYes();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Подтверждение'),
      titlePadding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      content: Text(widget.textConfirmation),
      backgroundColor: Theme.of(context).backgroundColor,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Нет',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
        TextButton(
          onPressed: _isLoading ? null : () => _yesAction(),
          child: const Text('Да',
              style: TextStyle(color: mainColor, fontSize: 18)),
        ),
      ],
    );
  }
}
