import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/screens/terms_and_conditions.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';
import 'about_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView(
                  children: [
                    TemplateTileContainerCardWithIcon(
                      backgroundColor: primaryColor,
                      icon: Icons.qr_code_scanner,
                      title: 'SCAN QR',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const QrCodeScanner();
                        }));
                      },
                    ),
                    12.h,
                    TemplateTileContainerCardWithIcon(
                      backgroundColor: primaryColor,
                      icon: FontAwesomeIcons.shieldHalved,
                      title: 'CONDITIONS AND TERMS',
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return TermsAndConditionsScreen();
                        }));
                      },
                    ),
                    12.h,
                    TemplateTileContainerCardWithIcon(
                      backgroundColor: primaryColor,
                      icon: FontAwesomeIcons.info,
                      title: 'ABOUT SJEKK',
                      onTap: () {
                        Navigator.pushNamed(context, AboutScreen.route);
                      },
                    ),
                    12.h,
                    TemplateTileContainerCardWithIcon(
                      backgroundColor: primaryColor,
                      icon: FontAwesomeIcons.clockRotateLeft,
                      title: 'HISTORY (Exp)',
                      onTap: () async {
                        // Navigator.pushNamed(context,PurchaseHistoryScreen.history);
                      },
                    ),
                  
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
