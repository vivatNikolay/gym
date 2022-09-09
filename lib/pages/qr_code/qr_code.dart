import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sportmen_in_gym/helpers/constants.dart';

import '../../models/subscription.dart';
import '../../controllers/db_controller.dart';

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
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrImage(
                            data: _dbController.getSportsman()!.email,
                            size: 300,
                            backgroundColor: Colors.white,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              fixedSize: Size.fromWidth(280),
                              primary: mainColor,
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
                              ' Close ',
                              style: TextStyle(
                                fontSize: 19,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
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
                onTap: () {},
              ),
            ),
          ]),
      ),
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
