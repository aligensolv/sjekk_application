import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:sjekk_application/core/utils/snackbar_utils.dart';
import 'package:url_launcher/url_launcher.dart';


class QrCodeScanner extends StatefulWidget {
  static const String router = '/qrcode_scanner';
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
                  SnackbarUtils.showSnackbar(
                    context, 
                    'Could not find barcode'
                  );
                                  mobileScannerController.dispose();

                } else {
                  final Barcode qrCodeValue = barcode.barcodes.first;
                  // mobileScannerController.dispose();
                  if(qrCodeValue.url?.url != null){
                    Uri uri = Uri.parse(qrCodeValue.url!.url);
                    if(await canLaunchUrl(uri)){
                      await launchUrl(uri);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

