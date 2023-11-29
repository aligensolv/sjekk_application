import 'package:flutter/material.dart';

import '../theme/icon_theme.dart';

class TemplateIcon extends StatelessWidget {
  final IconData iconData;

  const TemplateIcon(this.iconData, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      iconData,
      color: iconThemeData.color,
      size: iconThemeData.size,
    );
  }
}
