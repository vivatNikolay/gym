import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'widgets/custom_search_delegate.dart';
import 'widgets/qr_scan_item.dart';

class ManagerQrPage extends StatefulWidget {
  const ManagerQrPage({Key? key}) : super(key: key);

  @override
  State<ManagerQrPage> createState() => _ManagerQrPageState();
}

class _ManagerQrPageState extends State<ManagerQrPage> {
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IconButton(
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: CustomSearchDelegate(),
              );
            },
            icon: const Icon(Icons.search, size: 28)),
        IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const QrScanItem()));
            },
            icon: const Icon(Icons.qr_code_2, size: 28)),
        IconButton(
            onPressed: () {

            },
            icon: const Icon(Icons.add, size: 28)),
      ],
    );
  }
}
