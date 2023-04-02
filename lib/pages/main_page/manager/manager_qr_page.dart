import 'package:flutter/material.dart';

import '../../../models/account.dart';
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
      title: 'QR-код',
      floatingActionButton: FloatingAddButton(
        text: 'Создать аккаунт',
        onPressed: () => Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ManagerProfileEdit(
                account: Account.emptySportsman(), isEdit: false))),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 20, 12, 10),
        child: SingleChildScrollView(
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
                data: 'Scan qr-code!',
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const QrScanPage()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
