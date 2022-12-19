import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../services/db/account_db_service.dart';
import 'widgets/custom_search_delegate.dart';
import 'widgets/qr_scan_page.dart';

class ManagerQrPage extends StatefulWidget {
  const ManagerQrPage({Key? key}) : super(key: key);

  @override
  State<ManagerQrPage> createState() => _ManagerQrPageState();
}

class _ManagerQrPageState extends State<ManagerQrPage> {
  final AccountDBService _accountDBService = AccountDBService();
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');

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
                const Text('Scan qr code',
                    style: TextStyle(fontSize: 22, color: Colors.black)),
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
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
              ),
              child: IconButton(
                  onPressed: () {
                    showSearch(
                      context: context,
                      delegate:
                          CustomSearchDelegate(_accountDBService.getFirst()!),
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
                  onPressed: () {},
                  icon: const Icon(Icons.add, size: 34, color: Colors.black)),
            ),
          ],
        ),
      ],
    );
  }
}
