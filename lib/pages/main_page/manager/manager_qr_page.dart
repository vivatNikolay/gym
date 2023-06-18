import 'package:flutter/material.dart';
import 'package:localization/localization.dart';

import '../../training_list/widgets/floating_add_button.dart';
import '../../widgets/main_scaffold.dart';
import '../widgets/qr_item.dart';
import 'manager_profile_edit.dart';
import 'widgets/custom_search_delegate.dart';
import 'widgets/qr_scan_page.dart';
import 'widgets/search_field.dart';

class ManagerQrPage extends StatefulWidget {
  const ManagerQrPage({Key? key}) : super(key: key);

  @override
  State<ManagerQrPage> createState() => _ManagerQrPageState();
}

class _ManagerQrPageState extends State<ManagerQrPage> {

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: 'qrCode'.i18n(),
      floatingActionButton: FloatingAddButton(
        text: 'createAccount'.i18n(),
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ManagerProfileEdit())),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
        child: Column(
          children: [
            SearchField(
              onTap: () => showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.14),
            QrItem(
              data: 'scan qr-code'.i18n(),
              onTap: () {
                Navigator.of(context).pushNamed(QrScanPage.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }
}
