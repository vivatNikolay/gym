import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../../helpers/constants.dart';
import '../../widgets/main_scaffold.dart';
import 'manager_qr.dart';

class ManagerPage extends StatelessWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage(gantelImage),
          fit: BoxFit.cover,
          opacity: 0.65,
        ),
        color: Theme.of(context).colorScheme.background,
      ),
      child: MainScaffold(
        title: 'qrCode'.i18n(),
        body: const ManagerQr(),
      ),
    );
  }
}
