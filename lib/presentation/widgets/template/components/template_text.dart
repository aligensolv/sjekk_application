import 'package:flutter/material.dart';
import 'package:sjekk_application/presentation/widgets/template/theme/colors_theme.dart';


class TemplateHeaderText extends StatelessWidget {
  final String text;
  TextDecoration? decoration;
  Color? color;

  TemplateHeaderText(this.text, {super.key, this.color, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(
      fontSize: 24,
      color: color ?? textColor,
      decoration: decoration
    ));
  }
}

class TemplateHeadlineText extends StatelessWidget {
  final String text;
  double? size;
  Color? color;
  TemplateHeadlineText(this.text, {super.key, this.size = 20, this.color = textColor});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: TextStyle(
      fontSize: size,
      color: color
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