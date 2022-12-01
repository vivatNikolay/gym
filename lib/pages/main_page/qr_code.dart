import 'package:flutter/material.dart';
import 'package:sportmen_in_gym/pages/main_page/sportsman_qr.dart';

import '../../services/db/account_db_service.dart';
import '../../helpers/constants.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final AccountDBService _accountDBService = AccountDBService();

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
        child: switcherByRole(),
      ),
    );
  }

  Widget switcherByRole() {
    switch (_accountDBService.getFirst()!.role) {
      case 'MANAGER': {
        break;
      }
      case 'ADMIN': {
        break;
      }
    }
    return const SportsmanQr();
  }
}
