import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';

import '../../models/subscription.dart';
import '../../controllers/db_controller.dart';
import 'history.dart';
import 'widgets/qr_item.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final DBController _dbController = DBController.instance;
  late String _subscriptionProgress;
  final DateFormat formatterDate = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    super.initState();

    _subscriptionProgress = getProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR code'),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/gantel.jpg'),
            fit: BoxFit.cover,
            alignment: Alignment.bottomLeft,
            opacity: 0.5,
          ),
        ),
        child: ListView(padding: const EdgeInsets.only(top: 30), children: [
            QrItem(data: _dbController.getSportsman()!.email),
            const SizedBox(height: 20),
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0),
              ),
              color: Colors.white,
              child: ListTile(
                leading: const Icon(Icons.credit_card, size: 26, color: mainColor),
                minLeadingWidth: 22,
                title: const Text(
                  'Subscription',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black
                  ),
                ),
                subtitle: Text(
                  _subscriptionProgress,
                  style: const TextStyle(
                    fontSize: 17,
                      color: Colors.black
                  ),
                ),
                onTap: _dbController.getSportsman()!.subscription != null
                  ? () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => const History()))
                  : null,
            ),
          ),
          ]),
      ),
    );
  }

  String getProgress() {
    Subscription? subscription = _dbController.getSportsman()!.subscription;
    if (subscription != null) {
      return '${subscription.visitCounter}/${subscription.numberOfVisits} '
          'until ${formatterDate.format(subscription.dateOfEnd)}';
    } else {
      return '(no)';
    }
  }
}
