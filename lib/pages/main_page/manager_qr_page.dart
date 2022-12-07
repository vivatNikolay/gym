import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../helpers/constants.dart';
import '../../models/account.dart';
import '../../models/subscription.dart';
import '../../services/db/account_db_service.dart';
import '../../services/http/subscription_http_service.dart';
import 'widgets/qr_scan_item.dart';

class ManagerQrPage extends StatefulWidget {
  const ManagerQrPage({Key? key}) : super(key: key);

  @override
  State<ManagerQrPage> createState() => _ManagerQrPageState();
}

class _ManagerQrPageState extends State<ManagerQrPage> {
  final AccountDBService _accountDBService = AccountDBService();
  final SubscriptionHttpService _httpService = SubscriptionHttpService();
  Future<List<Subscription>>? _futureSubscription;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      IconButton(
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const QrScanItem()));
          },
          icon: const Icon(Icons.qr_code_2, size: 28)
      ),
    ]);
  }
}
