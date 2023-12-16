
import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

import 'printers_settings.dart';

class SettingsScreen extends StatelessWidget {
  static const String settingsScreen = '/settings';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: scaffoldColor,
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: ListView(
            children: [
              TemplateTileContainerCardWithIcon(
                backgroundColor: primaryColor,
                title: 'PRINTERS' ,
                icon: Icons.print,
                onTap: (){
                  Navigator.of(context).pushNamed(PrintersSettings.route);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}