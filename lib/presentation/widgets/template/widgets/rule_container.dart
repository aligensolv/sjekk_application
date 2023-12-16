import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/extensions/sizedbox_extension.dart';

import '../theme/colors_theme.dart';

class RuleContainer extends StatelessWidget {
  final VoidCallback? onTap;
  final IconData icon;
  final String title;
  Color? backgroundColor;  
  double widthFactor;
  double? height;

  RuleContainer({super.key,this.height, this.widthFactor = 1, this.onTap, required this.icon, required this.title, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return InkWell(
      onTap: onTap,
      child: Container(
        // height: height,
        constraints: BoxConstraints(
          minHeight: 50,
          minWidth: double.infinity,
          maxHeight: 240
        ),
        width: media.width * widthFactor,
        decoration: BoxDecoration(
          color: backgroundColor ?? primaryColor,
          borderRadius: BorderRadius.circular(0.0),
      
        ),
        alignment: Alignment.center,
        child: Row(
          children: [
            Container(
              color: Colors.black38,
              width: 50,
              alignment: Alignment.center,
              height: double.infinity,
              child: Text('§',style: TextStyle(
                color: Colors.white,
                fontSize: 24
              ),),
            ),
            12.w,
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}