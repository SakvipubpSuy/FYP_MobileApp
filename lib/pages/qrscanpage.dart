// import 'dart:convert';
// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:fyp_mobileapp/pages/dashboard.dart';
// import 'package:fyp_mobileapp/pages/decks_cards/individualcardpage.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// import '../api/card_service.dart';

// class QRScan extends StatefulWidget {
//   const QRScan({Key? key}) : super(key: key);

//   @override
//   State<StatefulWidget> createState() => _QRScanState();
// }

// class _QRScanState extends State<QRScan> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   Barcode? result;
//   QRViewController? controller;

//   // In order to get hot reload to work we need to pause the camera if the platform
//   // is android, or resume the camera if the platform is iOS.
//   @override
//   void reassemble() {
//     super.reassemble();
//     if (Platform.isAndroid) {
//       controller!.pauseCamera();
//     } else if (Platform.isIOS) {
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.black),
//           onPressed: () {
//             Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => Dashboard(),
//                 ));
//           },
//         ),
//         automaticallyImplyLeading: false,
//         title: const Text("Scan QRCODE",
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 20,
//               fontWeight: FontWeight.bold,
//             )),
//         backgroundColor: Colors.white,
//       ),
//       body: Column(
//         children: [
//           Expanded(flex: 4, child: _buildQrView(context)),
//         ],
//       ),
//     );
//   }

//   Widget _buildQrView(BuildContext context) {
//     // For this example we check how width or tall the device is and change the scanArea and overlay accordingly.
//     var scanArea = (MediaQuery.of(context).size.width < 400) ? 300.0 : 350.0;
//     // To ensure the Scanner view is properly sizes after rotation
//     // we need to listen for Flutter SizeChanged notification and update controller
//     return QRView(
//       key: qrKey,
//       onQRViewCreated: _onQRViewCreated,
//       overlay: QrScannerOverlayShape(
//           borderColor: Colors.white,
//           borderRadius: 10,
//           borderLength: 30,
//           borderWidth: 10,
//           cutOutSize: scanArea),
//       onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//       this.controller?.resumeCamera();
//     });

//     controller.scannedDataStream.listen((scanData) async {
//       if (scanData.code != null) {
//         print(scanData.code);
//         // Navigator.pop(context, scanData.code);
//         String trimmedCode =
//             scanData.code!.substring(1, scanData.code!.length - 1);
//         int intTrimmedCode = int.parse(trimmedCode);
//         await CardService().sendScanResult(context, intTrimmedCode);
//         await Future.delayed(const Duration(milliseconds: 500));
//         controller.dispose();
//       }
//     });
//   }

//   void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
//     if (!p) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('No Permission')),
//       );
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../api/card_service.dart';
// import 'dashboard.dart';

class QRScan extends StatefulWidget {
  const QRScan({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    } else if (Platform.isIOS) {
      controller?.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        title: const Text("Scan QRCODE",
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: isScanning ? _buildQrView(context) : Container(),
          ),
          Expanded(
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isScanning = true;
                  });
                },
                child: const Text('Start Scanning'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400) ? 300.0 : 350.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });

    controller.scannedDataStream.listen((scanData) async {
      if (scanData.code != null) {
        controller.pauseCamera();
        await CardService().sendScanResult(context, scanData.code!);
        setState(() {
          isScanning = false;
        });
      }
    });
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
