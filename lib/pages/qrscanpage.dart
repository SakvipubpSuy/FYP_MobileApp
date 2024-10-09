import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../api/card_service.dart';
import '../db/card_helper.dart';
import '../models/card.dart';
import '../utils/connectivity_service.dart';
import 'no_connection_page.dart';

class QRScan extends StatefulWidget {
  const QRScan({super.key});

  @override
  State<StatefulWidget> createState() => _QRScanState();
}

class _QRScanState extends State<QRScan> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool isScanning = false;
  bool isConnected = true;
  final CardService _cardService = CardService();

  @override
  void initState() {
    super.initState();
    _checkConnectivity();
  }

  void _checkConnectivity() async {
    bool connectionStatus = await ConnectivityService().checkConnection();
    setState(() {
      isConnected = connectionStatus;
    });
  }

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
    return isConnected
        ? Scaffold(
            appBar: AppBar(
              centerTitle: true,
              automaticallyImplyLeading: false,
              title: const Text(
                "Scan QRCODE",
                style: TextStyle(
                  color: Colors.amber,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              backgroundColor: const Color(0xFF2F2F85),
            ),
            body: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: isScanning ? _buildQrView(context) : Container(),
                  ),
                  Expanded(
                    child: Center(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1A4D), Color(0xFF2F2F85)],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: () {
                            if (isConnected) {
                              setState(() {
                                isScanning = true;
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('No Internet Connection')),
                              );
                            }
                          },
                          child: const Text(
                            'Start Scanning',
                            style: TextStyle(color: Colors.amber),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : NoConnectionPage(); // Show the NoConnectionPage if not connected
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
        bool? confirmed =
            await _showConfirmationDialog(context, scanData.code!);
        if (confirmed == true) {
          await CardService().sendScanResult(context, scanData.code!);
          // Save the card locally after confirmation
          await _saveScannedCard(scanData.code!);
        }
        setState(() {
          isScanning = false;
        });
        controller.resumeCamera();
      }
    });
  }

  Future<bool?> _showConfirmationDialog(
      BuildContext context, String scanData) async {
    try {
      // Decrypt the scanData to get the actual card ID
      String decryptedCardId = await _cardService.decrypt(scanData);

      // Fetch card details using the decrypted card ID
      CardModel cardDetails = await _cardService.getCardByID(decryptedCardId);

      String cardName = cardDetails.cardName;
      int cardExp = cardDetails.cardTier.cardXP;
      int energyRequired = cardDetails.cardTier.cardEnergyRequired;
      String tier = cardDetails.cardTier.cardTierName;
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Scan'),
            content: Text(
                'Card: $cardName\nCard Tier: $tier\nEXP: $cardExp\nEnergy Required: $energyRequired'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      // Handle any errors (e.g., failed to decrypt or fetch card details)
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('Failed to fetch card details.'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  // This function will save the card to the local database
  Future<void> _saveScannedCard(String scanData) async {
    try {
      String decryptedCardId = await _cardService.decrypt(scanData);

      // Fetch card details
      CardModel cardDetails = await _cardService.getCardByID(decryptedCardId);

      // Assuming you have a method to save the card in local database
      await CardDbHelper().saveCard(cardDetails);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Card saved locally')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save card locally')),
      );
    }
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
