import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sjekk_application/presentation/screens/scan_result_screen.dart';


class QrCodeScanner extends StatefulWidget {
  static const String scanner = '/qrcode_scanner';
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  bool qr = false;
  bool active = false;
  MobileScannerController mobileScannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: mobileScannerController,
              
              onDetect: (barcode) async {
                if (barcode.raw == null) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Null")));
                                  mobileScannerController.dispose();

                } else {
                  final qrCodeValue = barcode.barcodes.first;
                  mobileScannerController.dispose();
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: ((context) => ScanResultScreen(result: qrCodeValue.rawValue.toString(),)))
                  );

                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

