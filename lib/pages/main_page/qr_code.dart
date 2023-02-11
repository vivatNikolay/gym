import 'package:flutter/material.dart';

import '../../helpers/constants.dart';

class QrCode extends StatelessWidget {
  final Widget child;
  const QrCode(this.child, {Key? key}) : super(key: key);

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
        child: child,
      ),
    );
  }
}
