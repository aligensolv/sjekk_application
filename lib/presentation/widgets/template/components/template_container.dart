import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';

class TemplateContainerCardWithIcon extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String title;
  Color? backgroundColor;  
  double widthFactor;
  double? height;

  TemplateContainerCardWithIcon({super.key,this.height, this.widthFactor = 1, this.onTap, required this.icon, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: media.width * widthFactor,
        padding: EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          borderRadius: BorderRadius.circular(0.0),

        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon, // Replace with category-specific icons
              color: Colors.white,
              size: 48,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TemplateContainerCard extends StatelessWidget {
  final VoidCallback? onTap;
  final String title;
  double widthFactor;
  double? height;

  Color? backgroundColor;
  Alignment? alignment;

    TemplateContainerCard({
    super.key, this.alignment = Alignment.center,this.onTap,required this.title,this.height, this.backgroundColor, this.widthFactor = 1});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: media.width * widthFactor,
        height: height,
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          borderRadius: BorderRadius.circular(0.0),

        ),
        alignment: alignment,
        child: Text(
          title,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
