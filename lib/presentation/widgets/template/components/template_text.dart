import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';


class TemplateHeaderText extends StatelessWidget {
  final String text;
  const TemplateHeaderText(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 24,
      color: textColor
    ),);
  }
}

class TemplateHeadlineText extends StatelessWidget {
  final String text;
  double? size;
  TemplateHeadlineText(this.text, {super.key, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: size
    ),);
  }
}

class TemplateParagraphText extends StatelessWidget {
  final String text;
  Color? color;
  TemplateParagraphText(this.text,{super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: 16,
      color: color
    ));
  }
}