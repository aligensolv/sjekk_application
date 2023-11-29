import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:sjekk_application/presentation/providers/auth_provider.dart';
import 'package:sjekk_application/presentation/screens/qrcode_scanner.dart';
import 'package:sjekk_application/presentation/screens/terms_and_conditions.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/helpers/theme_helper.dart';
import '../widgets/template/components/template_list_tile.dart';
import 'about_screen.dart';

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  TemplateListTile(
                    backgroundColor: primaryColor,
                    leading: Icons.qr_code_scanner,
                    icon: Icons.chevron_right,
                    title: 'Scan qrode',
                    titleColor: Colors.white,
                    leadingColor: Colors.white,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const QrCodeScanner();
                      }));
                    },
                  ),
                  12.h,
                  TemplateListTile(
                    backgroundColor: primaryColor,
                    leading: FontAwesomeIcons.shieldHalved,
                    icon: Icons.chevron_right,
                    title: 'Conditions & Terms',
                    titleColor: Colors.white,
                    leadingColor: Colors.white,
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return TermsAndConditionsScreen();
                      }));
                    },
                  ),
                  12.h,
                  TemplateListTile(
                    backgroundColor: primaryColor,
                    leading: FontAwesomeIcons.info,
                    icon: Icons.chevron_right,
                    title: 'About Sjekk',
                    titleColor: Colors.white,
                    leadingColor: Colors.white,
                    onTap: () {
                      Navigator.pushNamed(context, AboutScreen.route);
                    },
                  ),
                  12.h,
                  TemplateListTile(
                    backgroundColor: primaryColor,
                    leading: FontAwesomeIcons.clockRotateLeft,
                    icon: Icons.chevron_right,
                    titleColor: Colors.white,
                    leadingColor: Colors.white,
                    title: 'History (Experimential)',
                    onTap: () async {
                      // Navigator.pushNamed(context,PurchaseHistoryScreen.history);
                    },
                  ),
                  
                  // buildMenuItem(
                  //     iconData: FontAwesomeIcons.arrowRightFromBracket,
                  //     text: 'Logout',
                  //     onTap: () {

                  //     },
                  //     textColor: Colors.red,
                  //     trailingIconColor: Colors.red,
                  //     leadingIconColor: Colors.red),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMenuItem({
    required IconData iconData,
    required String text,
    required VoidCallback onTap,
    Color? leadingIconColor,
    Color? trailingIconColor,
    Color? textColor,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 2),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(
          iconData,
          size: 26,
          color: leadingIconColor ?? ThemeHelper.primaryColor,
        ),
        title: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor ?? ThemeHelper.primaryColor,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 20,
          color: trailingIconColor ?? ThemeHelper.primaryColor,
        ),
        onTap: onTap,
      ),
    );
  }
}
