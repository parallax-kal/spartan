import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:spartan/notifiers/CurrentCribIdNotifier.dart';

class ScanQrcodeScreen extends StatefulWidget {
  const ScanQrcodeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ScanQrcodeScreenState();
}

class _ScanQrcodeScreenState extends State<ScanQrcodeScreen> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  bool cameraPaused = false;

  bool sentResult = false;

  @override
  void initState() {
    sentResult = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 4,
            child: _buildQrView(context),
          ),
          Expanded(
            flex: 1,
            child: FittedBox(
              fit: BoxFit.contain,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0xFF008F39),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          await controller?.toggleFlash();
                          setState(() {});
                        },
                        icon: FutureBuilder(
                          future: controller?.getFlashStatus(),
                          builder: (context, snapshot) {
                            return Icon(
                              snapshot.data == true
                                  ? Icons.flash_on
                                  : Icons.flash_off,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 40),
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: const Color(0XFF1471C7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        onPressed: () async {
                          await controller?.flipCamera();
                          setState(() {});
                        },
                        icon: FutureBuilder(
                          future: controller?.getCameraInfo(),
                          builder: (context, snapshot) {
                            return const Icon(
                              Icons.cameraswitch,
                              color: Colors.white,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Center(
                    child: IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: const Color(0XFF002E58),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      onPressed: () async {
                        if (cameraPaused) {
                          await controller?.resumeCamera();
                        } else {
                          await controller?.pauseCamera();
                        }
                        setState(() {
                          cameraPaused = !cameraPaused;
                        });
                      },
                      icon: Icon(cameraPaused ? Icons.play_arrow : Icons.pause,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    // For this example we check how width or tall the crib is and change the scanArea and overlay accordingly.
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;

    CurrentCribIdNotifier currentCribIdNotifier =
        Provider.of<CurrentCribIdNotifier>(context);

    void onQRViewCreated(QRViewController controller) {
      setState(() {
        this.controller = controller;
      });
      controller.scannedDataStream.listen((scanData) {
        String? data = scanData.code;
        if (data == null || currentCribIdNotifier.cribId != null) {
          return;
        }
        List<String> results = data.split("=");
        if (results.isEmpty || results.length != 2) {
          return;
        }

        String result = results.last.trim();
        currentCribIdNotifier.setCribId(result);
        GoRouter.of(context).push('/crib/result', extra: {
          'result': result,
        });
      });
    }

    // To ensure the Scanner view is properly sizes after rotation
    // we need to listen for Flutter SizeChanged notification and update controller
    return QRView(
      key: qrKey,
      onQRViewCreated: onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.red,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
