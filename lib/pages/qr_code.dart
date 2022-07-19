import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../models/subscription.dart';
import '../controllers/db_controller.dart';

class QrCode extends StatefulWidget {
  const QrCode({Key? key}) : super(key: key);

  @override
  State<QrCode> createState() => _QrCodeState();
}

class _QrCodeState extends State<QrCode> {
  final DBController _dbController = DBController.instance;
  late String _subscriptionProgress;
  late double currentBrightness;

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
      body: ListView(padding: const EdgeInsets.only(top: 30), children: [
          InkWell(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 98),
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(children: [
                QrImage(
                  data: _dbController.getSportsman()!.email,
                  size: 200,
                  backgroundColor: Colors.white,
                ),
                const Text(
                  'Show this QR-code manager of gym',
                  style: TextStyle(color: Colors.black, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            onTap: () async {
              await ScreenBrightness()
                  .current
                  .then((value) => currentBrightness = value);
              ScreenBrightness().setScreenBrightness(1);
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  backgroundColor: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: QrImage(
                          data: _dbController.getSportsman()!.email,
                          size: 300,
                          backgroundColor: Colors.white,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.black12,
                          side: const BorderSide(
                              color: Colors.deepOrangeAccent, width: 2),
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: () {
                          ScreenBrightness()
                              .setScreenBrightness(currentBrightness);
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            color: Colors.deepOrangeAccent,
                            fontSize: 19,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          ListTile(
            leading:
                const Icon(Icons.credit_card, color: Colors.deepOrangeAccent),
            minLeadingWidth: 24,
            title: const Text(
              'Subscription',
            ),
            subtitle: Text(
              _subscriptionProgress,
            ),
            onTap: () {},
          ),
        ]),
    );
  }

  String getProgress() {
    Subscription? subscription = _dbController.getSportsman()!.subscription;
    if (subscription != null) {
      return '${subscription.visitCounter}/${subscription.numberOfVisits}';
    } else {
      return '(no)';
    }
  }
}
