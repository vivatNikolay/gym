import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../widgets/qr_item.dart';
import '../../widgets/custom_search_delegate.dart';
import 'widgets/qr_scan_page.dart';
import '../../widgets/search_field.dart';

class ManagerQr extends StatelessWidget {
  const ManagerQr({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
      child: Column(
        children: [
          SearchField(
            onTap: () => showSearch(
              context: context,
              delegate: CustomSearchDelegate(true),
            ),
          ),
          SizedBox(height: size.height * 0.14),
          QrItem(
            data: 'scan qr-code'.i18n(),
            onTap: () {
              Navigator.of(context).pushNamed(QrScanPage.routeName);
            },
          ),
        ],
      ),
    );
  }
}
