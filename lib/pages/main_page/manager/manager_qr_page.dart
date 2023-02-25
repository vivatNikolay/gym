import 'package:flutter/material.dart';

import '../../../models/account.dart';
import 'manager_profile_edit.dart';
import 'widgets/custom_search_delegate.dart';
import 'widgets/qr_scan_page.dart';

class ManagerQrPage extends StatefulWidget {
  const ManagerQrPage({Key? key}) : super(key: key);

  @override
  State<ManagerQrPage> createState() => _ManagerQrPageState();
}

class _ManagerQrPageState extends State<ManagerQrPage> {

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          child: Container(
            width: 210,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
            ),
            child: Column(
              children: [
                Image.asset('images/qr_scan.png'),
                const SizedBox(height: 5),
              ],
            ),
          ),
          onTap: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const QrScanPage()));
          },
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate:
                          CustomSearchDelegate(),
                    );
                  },
                  icon:
                      const Icon(Icons.search, size: 34, color: Colors.black)),
            ),
            const SizedBox(width: 20),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ManagerProfileEdit(
                            account: Account.emptySportsman(), isEdit: false)));
                  },
                  icon: const Icon(Icons.add, size: 34, color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }
}
