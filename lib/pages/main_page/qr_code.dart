import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportmen_in_gym/pages/main_page/sportsman_qr.dart';

import '../../models/sportsman.dart';
import '../../services/db/sportsman_db_service.dart';
import '../../services/http/subscription_http_service.dart';
import '../../helpers/constants.dart';
import '../../models/subscription.dart';
import 'history_of_sub.dart';
import 'widgets/qr_item.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final SportsmanDBService _sportsmanDBService = SportsmanDBService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.only(top: 30),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(gantelImage),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            opacity: 0.5,
          ),
        ),
        child: const SportsmanQr(),
      ),
    );
  }
}
