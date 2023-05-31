import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../manager_profile.dart';
import '../../../../helpers/constants.dart';

class QrScanPage extends StatefulWidget {
  static const routeName = '/qr-scan';
  const QrScanPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QrScanPageState();
}

class _QrScanPageState extends State<QrScanPage> {
  String? result;
  QRViewController? qrController;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    qrController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: mainColor,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: MediaQuery.of(context).size.width * 0.8,
              ),
            ),
            Positioned(child: buildResult(), bottom: 20),
          ],
        ),
      ),
    );
  }

  Widget buildResult() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white30
    ),
    child: Text(
      result != null ? 'Результат : ${result!}' : 'Отсканируйте QR-код',
      maxLines: 3,
      style: const TextStyle(color: Colors.white, fontSize: 18),
    ),
  );

  void _onQRViewCreated(QRViewController controller) {
    setState(() => qrController = controller);
    controller.scannedDataStream.listen((scanData) {
      setState(() => result = scanData.code!);
      profileRoute();
    });
    controller.resumeCamera();
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      qrController!.pauseCamera();
    }
    qrController!.resumeCamera();
  }

  void profileRoute() async {
    qrController?.pauseCamera();
    await Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ManagerProfile(id: result!)))
    .then((value) => qrController!.resumeCamera());
  }
}