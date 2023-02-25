import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

import '../manager_profile.dart';
import '../../../../helpers/constants.dart';

class QrScanPage extends StatefulWidget {
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
  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
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
    await Navigator.push(context,
        MaterialPageRoute(
            builder: (context) => ManagerProfile(email: result!)))
    .then((value) => qrController!.resumeCamera());
  }
}