import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/components/template_text.dart';

// enum OptionMenuFlags{
//   normal,
//   save,
//   delete,

// }

class TemplateOption extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  Color? backgroundColor;
  Color? iconColor;
  Color? textColor;
  
  TemplateOption({
    super.key, 
    required this.text, 
    required this.icon, 
    required this.onTap,

    this.backgroundColor,
    this.iconColor,
    this.textColor
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor ?? Colors.white,
        padding: EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TemplateParagraphText(text,color: textColor,),
            Icon(icon, size: 30,color: iconColor,)
          ],
        ),
      ),
    );
  }
}