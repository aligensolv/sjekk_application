
import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_list_tile.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import '../../core/helpers/theme_helper.dart';
import 'printers_settings.dart';

class SettingsScreen extends StatelessWidget {
  static const String settingsScreen = '/settings';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldColor,
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            SizedBox(height: 20),
            TemplateListTile(
              backgroundColor: primaryColor,
              title: 'Printers' ,
              leading: Icons.print_outlined,
              icon: Icons.chevron_right,
              titleColor: Colors.white,
              leadingColor: Colors.white,
              onTap: (){
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const PrintersSettings())
                );
              },
            )
          ],
        ),
      ),
    );
  }
}