import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_container.dart';

import 'template_option.dart';

class TemplateOptionsMenu extends StatelessWidget {
  final List<TemplateOption> options;
  final String headerText;
  Color? headerColor;

  TemplateOptionsMenu({
    super.key, 
    required this.options,
    required this.headerText,
    this.headerColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(
        sigmaX: 10,
        sigmaY: 10
      ),
      child: AlertDialog(
        contentPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        backgroundColor: Colors.black45,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TemplateContainerCard(
              title: headerText,
              backgroundColor: headerColor,
            ),
            ...options
          ],
        ),
      ),
    );
  }
}