import 'package:flutter/material.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../../helpers/constants.dart';

class QrItem extends StatelessWidget {
  final String data;
  late double currentBrightness;

  QrItem({required this.data, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: QrImage(
          data: data,
          size: 200,
          backgroundColor: Colors.white,
        ),
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
                    data: data,
                    size: 280,
                    backgroundColor: Colors.white,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size.fromWidth(270),
                      primary: mainColor,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: () {
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
        ).then((value) => ScreenBrightness()
            .setScreenBrightness(currentBrightness));
      },
    );
  }
}
