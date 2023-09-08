import 'package:flutter/material.dart';
import 'package:localization/localization.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../helpers/constants.dart';

class QrDialog extends StatelessWidget {
  final String data;

  const QrDialog({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          borderRadius: BorderRadius.circular(25),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: data,
              size: 280,
              foregroundColor: Theme.of(context).iconTheme.color?.withOpacity(1),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: const Size.fromWidth(270),
                backgroundColor: mainColor,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                'close'.i18n(),
                style: const TextStyle(
                  fontSize: 19,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
